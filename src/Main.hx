import haxe.Json;
import haxe.io.Input;
import haxe.io.Output;
import haxe.io.Bytes;
import haxe.io.Path;
import sys.io.File;

import result.Result;

class Main {
    static public function main():Void {        
			var logFilePath = "debug.log";
			try {
				// Open the file in Append mode
				logOutput = File.append(logFilePath);
				log("--- LSP Server Started ---");
				log('Logging to: ' + logFilePath);
			} catch (e:Dynamic) {
				// If we can't open a log file, logOutput remains null and we won't log.
				logOutput = null;
			}

			try {
				var message = {}; 
				while(true) {
					var result = decodeMessage(Sys.stdin());
					switch result {
						case Error(e):
							log(e);
						case Ok(t): {
							message = t;
							return;
						}
					}
				}

				log('Got message $message');
			} catch (e: Dynamic) {
				log(e);
			}
    }

		static var logOutput:Null<Output> = null;
		static function log(message: String) {
			if (logOutput != null) {
				try {
					var timestamp = Date.now().getHours() + ":" 
						+ Date.now().getMinutes() + ":" 
						+ Date.now().getSeconds();
					logOutput.writeString('[' + timestamp + '] ' + message + "\n");
					logOutput.flush();
				} catch (e:Dynamic) {
					// Ignore logging errors to prevent crashing the main process
				}
			}
		}

		static public function encodeMessage(msg: Dynamic): String {
			var json = Json.stringify(msg);
			var header = 'Content-Type: "application/vscode-jsonrpc; charset=utf-8"\r\n';
			header += 'Content-Length: ${Bytes.ofString(json).length}\r\n';
			header += "\r\n";

			return header + json;
		}

		static public function decodeMessage(msg: Input): Result<Dynamic> {
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
				obj.header = header;
				return Ok(obj);
			} catch (e: Dynamic) {
				return Error(e);
			}
		}
}
