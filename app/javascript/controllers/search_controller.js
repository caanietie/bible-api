import { Controller } from "@hotwired/stimulus";
import requestChapter from "../requestChapter";

export default class extends Controller {
	static targets = ["search"];
	searchBible(event) {
		event.preventDefault();
		if (!this.searchTarget.value) return;
		const addr = "http://localhost:3000/kjv_bible/api/kjv_bible/search";
		const bibleRoot = document.querySelector("#bible-root");
		fetch(`${addr}/${this.searchTarget.value}`)
			.then(response => response.json())
			.then(response => {
				bibleRoot.innerHTML = "";
				this.searcResults(bibleRoot, response.data)
			})
			.catch(error => {
				bibleRoot.innerHTML = `<p>${error.message}</p>`
			})
	}
	searcResults(bibleRoot, responseData) {
		const addr = "http://localhost:3000/kjv_bible/api/kjv_bible";
		for (let itm of responseData) {
			const lnk = document.createElement("a");
			const { book_name, chapter, verse } = itm;
			lnk.href = `${addr}/${book_name}/${chapter}#${verse}`;
			lnk.textContent = `${book_name} ${chapter}:${verse}`;
			lnk.style = "display: block";
			lnk.onclick = event => {
				event.preventDefault();
				requestChapter(book_name, chapter);
			};
			bibleRoot.appendChild(lnk);
		}
	}
}