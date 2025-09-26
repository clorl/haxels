package result;

enum Result<T> {
	Ok(?t: Null<T>);
	Error(e: Dynamic);
}

class ResultTools {

	/**
	 * returns the inside type if `Ok`, will thrown an error if `Error`
	 */
	inline public static function unwrap<T>(result : Result<T>) : T {
		switch(result) {
			case Ok(r): return r;
			case Error(e): throw 'cannot unwrap result with error: $e';
		}
	}

	/**
	 * checks if the `Result` is `Ok`
	 */
	inline public static function isOk<T>(result : Result<T>) : Bool {
		switch(result) {
			case Ok(_): return true;
			case Error(_): return false;
		}
	}

	/**
	 * checks if the `Result` is `Error`
	 */
	inline public static function isError<T>(result : Result<T>) : Bool {
		return !isOk(result);
	}


	inline public static function print(result : Result<Dynamic>) : Void {
		switch(result) {
			case Ok(t):
				trace(t);
			case Error(e):
				trace(e);
		}
	}
}
