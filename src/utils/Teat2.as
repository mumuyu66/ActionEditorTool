package utils {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class Teat2 {
		private var fileIn : ByteArray = null;
		private var imageInfo : Array = new Array(7);
		private var buffer : ByteArray = null;
		private var samples : int = 4;
		private var m_width : int;
		private var m_height : int;

		public function getText(ba : ByteArray) : String {
			fileIn = ba;
			fileIn.position = 0;

			if (!readSignature())
				return null;

			var chunks : Array = getChunks();

			for each (var chunk : Object in chunks) {
				fileIn.position = chunk.position;
				if (chunk.type == "tEXt")
					return fileIn.readUTF();
			}

			return null;
		}

		public function GetWidth() : int {
			return m_width;
		}

		public function GetHeight() : int {
			return m_height;
		}

		public function decode(ba : ByteArray, iend : Boolean = false) : ByteArray {
			buffer = new ByteArray();
			fileIn = ba;
			fileIn.position = 0;

			if (!readSignature())
				return null;

			var chunks : Array = getChunks();
			var countIHDR : int = 0;
			var countPLTE : int = 0;
			var iendInfo : ByteArray;
			for (var i : int = 0; i < chunks.length; ++i) {
				fileIn.position = chunks[i].position;
				var validChunk : Boolean = true;
				if (chunks[i].type == "IEND") {
					iendInfo = chunks[i].iendInfo;
				}
				if (i == 0) {
					if (chunks[i].type == "IHDR")
						validChunk = processIHDR(chunks[i].length);
				} else {
					if (chunks[i].type == "PLTE")
						validChunk = processPLTE(chunks[i].length);
					else if (chunks[i].type == "IDAT")
						buffer.writeBytes(fileIn, fileIn.position, chunks[i].length);
				}

				if (chunks[i].type == "IHDR")
					++countIHDR;
				if (chunks[i].type == "PLTE")
					++countPLTE;

				if (!validChunk || countIHDR > 1 || countPLTE > 1)
					return null;
			}

			buffer.uncompress();

			if (iend) {
				return iendInfo;
			}
			return processIDAT();
		}

		private function readSignature() : Boolean {
			if (fileIn.readUnsignedInt() != 0x89504e47)
				return false;
			if (fileIn.readUnsignedInt() != 0x0D0A1A0A)
				return false;

			return true;
		}

		private function getChunks() : Array {
			var chunks : Array = [];
			var length : int = 0;
			var type : String = "";

			do {
				length = fileIn.readUnsignedInt();
				type = fileIn.readUTFBytes(4);
				chunks.push({type:type, position:fileIn.position, length:length, iendInfo:fileIn});
				fileIn.position += length + 4;
			} while (type != "IEND");

			return chunks;
		}

		private function processIHDR(cLength : int) : Boolean {
			if (cLength != 13)
				return false;

			imageInfo[0] = fileIn.readUnsignedInt();
			m_width = imageInfo[0];
			imageInfo[1] = fileIn.readUnsignedInt();
			m_height = imageInfo[1];
			imageInfo[2] = fileIn.readUnsignedByte();
			imageInfo[3] = fileIn.readUnsignedByte();
			imageInfo[4] = fileIn.readUnsignedByte();
			imageInfo[5] = fileIn.readUnsignedByte();
			imageInfo[6] = fileIn.readUnsignedByte();

			if (imageInfo[0] <= 0 || imageInfo[1] <= 0)
				return false;

			switch (imageInfo[2]) {
				case 1:
				case 2:
				case 4:
				case 8:
				case 16:
					break;
				default:
					return false;
			}

			switch (imageInfo[3]) {
				case 0:
					if (imageInfo[2] != 1 && imageInfo[2] != 2 && imageInfo[2] != 4 && imageInfo[2] != 8 && imageInfo[2] != 16)
						return false;
					break;
				case 2:
					if (imageInfo[2] != 8 && imageInfo[2] != 16)
						return false;
					break;
				case 3:
					if (imageInfo[2] != 1 && imageInfo[2] != 2 && imageInfo[2] != 4 && imageInfo[2] != 8)
						return false;
					break;
				case 4:
					if (imageInfo[2] != 8 && imageInfo[2] != 16)
						return false;
					break;
				case 6:
					if (imageInfo[2] != 8 && imageInfo[2] != 16)
						return false;
					break;
				default:
					return false;
			}

			if (imageInfo[4] != 0 || imageInfo[5] != 0)
				return false;
			if (imageInfo[6] != 0 && imageInfo[6] != 1)
				return false;

			return true;
		}

		private function processPLTE(cLength : int) : Boolean {
			if (cLength % 3 != 0)
				return false;
			if (imageInfo[3] == 0 || imageInfo[3] == 4)
				return false;
			return true;
		}

		private function processIDAT() : ByteArray {
			var movelen : uint = 0;
			var j : int;
			var i : int;
			var pdat : ByteArray;
			var index : uint = (imageInfo[0] << 2);
			for (j = 0; j < imageInfo[1]; j++) {
				var filter : int = buffer[movelen];
				movelen++;
				switch (filter) {
					case 0:
						break;
					case 1: {
							for (i = (samples); i < index; i++) {
								buffer[movelen + i] += buffer[movelen + i - samples];
							}
						}
						break;
					case 2: {
							pdat = new ByteArray();
							pdat.writeBytes(buffer, movelen - index - 1, index);

							for (i = 0; i < index; i++) {
								buffer[movelen + i] += pdat[i];
							}
						}
						break;
					case 3: {
							pdat = new ByteArray();
							pdat.writeBytes(buffer, movelen - index - 1, index);

							for (i = 0; i < samples; i++) {
								buffer[movelen + i] += pdat[i] / 2;
							}
							for (i = samples; i < index; i++) {
								buffer[movelen + i] += (buffer[movelen + i - samples] + pdat[i]) / 2;
							}
						}
						break;
					case 4: {
							pdat = new ByteArray();
							pdat.writeBytes(buffer, movelen - index - 1, index);

							for (i = 0; i < samples; i++) {
								buffer[movelen + i] += paeth(0, pdat[i], 0);
							}
							for (i = samples; i < index; i++) {
								buffer[movelen + i] += paeth(buffer[movelen + i - samples], pdat[i], pdat[i - samples]);
							}    
						}
						break;
				}
				movelen += (imageInfo[0] * 4);
			}

			var bd : BitmapData = new BitmapData(imageInfo[0], imageInfo[1], true, 0);
			movelen = 0;
			pdat = new ByteArray();
			for (j = 0; j < imageInfo[1]; j++) {
				for (i = 0; i < imageInfo[0]; i++) {
					pdat.writeByte(buffer[movelen + 1 + (i << 2) + 3]);
					pdat.writeByte(buffer[movelen + 1 + (i << 2) + 0]);
					pdat.writeByte(buffer[movelen + 1 + (i << 2) + 1]);
					pdat.writeByte(buffer[movelen + 1 + (i << 2) + 2]);
				}
				movelen += (imageInfo[0] * 4 + 1);
			}
			pdat.position = 0;
			return pdat;
		}

		private function paeth(a : int, b : int, c : int) : int {
			var p : int;
			var pa : int;
			var pb : int;
			var pc : int;
			p = (a) + (b) - (c)
			pa = Math.abs(b - c)
			pb = Math.abs(a - c)
			pc = Math.abs(a + b - (c << 1))
			if (pa <= pb && pa <= pc) {
				return a;
			} else if (pb <= pc) {
				return b
			}
			return c
		}
	}
} 
