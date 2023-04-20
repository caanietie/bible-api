import { Controller } from "@hotwired/stimulus";
import requestChapter, { bibleUrl } from "../requestChapter";

export default class extends Controller {
	static targets = ["search"];

	searchBible(event) {
		event.preventDefault();
		const searchValue = this.searchTarget.value.trim();
		if (!searchValue) return;
		const strFormat = (str, ...value) => [str, ...value].reduce(
			(acc, val) => acc.replace("%s", val));
		const msg = `There %s for ${searchValue.bold()}`;
		const bibleRoot = document.querySelector("#bible-root");
		fetch(`${bibleUrl}/search/${encodeURIComponent(searchValue)}`)
			.then(response => response.json())
			.then(response => {
				bibleRoot.innerHTML = "";
				if (response.search.data.length === 0)
					throw new Error(strFormat(msg, 'are no results'));
				else {
					const searchData = response.search.data
					const div = document.createElement('div');
					const ms = searchData.length === 1 ? 'is 1 result' :
						`are ${searchData.length} results`;
					div.innerHTML = strFormat(msg, ms);
					bibleRoot.appendChild(div);
					this.searchResults(bibleRoot, searchData);
				}
			})
			.catch(error => {
				bibleRoot.innerHTML = `<p>${error.message}</p>`;
			})
	}

	searchResults(bibleRoot, responseData) {
		const table = document.createElement("table");
		for (let { book_name, chapter, verse, info_text } of responseData) {
			table.appendChild(this.createTableRow(
				this.createVerseLink(book_name, chapter, verse),
				this.createVerseInfo(info_text)
			));
		}
		bibleRoot.appendChild(table);
	}

	createTableRow(verseLink, verseInfo) {
		const tr = document.createElement("tr");
		tr.appendChild(verseLink);
		tr.appendChild(verseInfo);
		return tr;
	}

	createVerseLink(book, chapter, verse) {
		const td = document.createElement("td");
		const lnk = document.createElement("a");
		lnk.href = `${bibleUrl}/${book}/${chapter}/${verse}`;
		lnk.textContent = `${book} ${chapter}:${verse}`;
		lnk.style = "display: block";
		lnk.onclick = event => {
			event.preventDefault();
			requestChapter(book, chapter);
		};
		td.appendChild(lnk);
		return td;
	}

	createVerseInfo(verseInfo) {
		const td = document.createElement("td");
		td.textContent = verseInfo;
		return td;
	}
}
