import { Controller } from "@hotwired/stimulus";
import requestChapter from "../requestChapter";

export default class extends Controller {
	static targets = ["book", "chapter"];
	connect() {
		this.chapterRequest(false);
	}
	chapterRequest(event) {
		if (event) event.preventDefault();
		requestChapter(this.bookTarget.value, this.chapterTarget.value);
	}
}