import haxe.Json;
import haxe.io.BytesInput;
import haxe.io.Bytes;

import result.Result;

class Main {
    static public function main():Void {
    }

		static public function encodeMessage(msg: Dynamic): String {
			var json = Json.stringify(msg);
			var header = 'Content-Type: "application/vscode-jsonrpc; charset=utf-8"\r\n';
			header += 'Content-Length: ${Bytes.ofString(json).length}\r\n';
			header += "\r\n";

			return header + json;
		}

		static public function decodeMessage(msg: BytesInput): Result<Dynamic> {
			try {
				var header = new lsp.Types.Header();
				var line = msg.readLine();
				var eolReached = true;

				do {
					if (line.length == 0) {
						eolReached = false;
						break;
					}

					header.setFromString(line);

					line = msg.readLine();
				} while (line != null);

				if (eolReached) {
					return Error("Header not found");
				}

				if (header.contentLength <= 0) {
					return Error("Couldn't read Content-Length or it is 0");
				}

				var content = msg.readString(header.contentLength);
				var obj = Json.parse(content);
				return Ok(obj);
			} catch (e: Dynamic) {
				return Error(e);
			}
		}
}
