package lsp;
import result.Result;

class Header {
	public var contentLength: Int;
	public var contentType: String;

	public function setFromString(line: String): Result<Dynamic> {
		var split = line.split(":");
		if (split.length == 2) {
			switch split[0] {
				case "Content-Length":
					var parsed = Std.parseInt(split[1]);
					if (parsed == null) {
						return Error('Cannot parse Content-Length to int: $line');
					}
					this.contentLength = parsed;
				case "Content-Type":
					this.contentType = split[1];
				default:
					trace('Unknown data in header: $line');
			}
		}
		return Ok();
	}

	public function toString() {
		return 'Content-Length: $contentLength\r\nContent-Type: $contentType';
	}

	public function new() {
	}
}

class Message {
	public var header: Header;
	public var content: String;

	public function new() {
		header = new Header();
	}
}
