import js.Browser;
import js.html.ButtonElement;
import js.html.TextAreaElement;
import js.html.Element;

class Main {
	static var inputUrl:TextAreaElement;
	static var outputUrl:TextAreaElement;
	static var inputCount:Element;
	static var outputCount:Element;
	static var clearBtn:ButtonElement;
	static var copyBtn:ButtonElement;
	static var toast:Element;

	static var HIRAGANA_RE:EReg = ~/[\u3040-\u309F]/g;

	static function main() {
		Browser.document.addEventListener("DOMContentLoaded", function(_) {
			inputUrl = cast Browser.document.getElementById("inputUrl");
			outputUrl = cast Browser.document.getElementById("outputUrl");
			inputCount = cast Browser.document.getElementById("inputCount");
			outputCount = cast Browser.document.getElementById("outputCount");
			clearBtn = cast Browser.document.getElementById("clearBtn");
			copyBtn = cast Browser.document.getElementById("copyBtn");
			toast = cast Browser.document.getElementById("toast");

			inputUrl.addEventListener("input", function(_) processUrls());
			clearBtn.addEventListener("click", function(_) clearAll());
			copyBtn.addEventListener("click", function(_) copyToClipboard());

			processUrls();
		});
	}

	static function processUrls():Void {
		var rawValue = inputUrl.value;
		var cleanedValue = HIRAGANA_RE.replace(rawValue, "");
		outputUrl.value = cleanedValue;
		inputCount.textContent = rawValue.length + " 文字";
		outputCount.textContent = cleanedValue.length + " 文字";
		copyBtn.disabled = StringTools.trim(cleanedValue).length == 0;
	}

	static function copyToClipboard():Void {
		if (outputUrl.value == null || outputUrl.value == "")
			return;
		var text = outputUrl.value;
		var nav = Browser.window.navigator;
		var clip = Reflect.field(nav, "clipboard");
		if (clip != null && Reflect.hasField(clip, "writeText")) {
			var promise = Reflect.callMethod(clip, Reflect.field(clip, "writeText"), [text]);
			if (promise != null && Reflect.hasField(promise, "then")) {
				Reflect.callMethod(promise, Reflect.field(promise, "then"), [function(_:Dynamic) showToast(), function(_:Dynamic) fallbackCopy(text)]);
				return;
			}
		}
		fallbackCopy(text);
	}

	static function fallbackCopy(text:String):Void {
		outputUrl.select();
		try {
			js.Lib.eval("document.execCommand('copy');");
			Browser.window.getSelection().removeAllRanges();
			showToast();
		} catch (e:Dynamic) {
			Browser.console.error("コピー失敗: " + Std.string(e));
			Browser.window.alert("コピーに失敗しました。ブラウザの権限を確認してください。");
		}
	}

	static function showToast():Void {
		toast.classList.add("show");
		Browser.window.setTimeout(function() toast.classList.remove("show"), 2000);
	}

	static function clearAll():Void {
		inputUrl.value = "";
		processUrls();
		inputUrl.focus();
	}
}
