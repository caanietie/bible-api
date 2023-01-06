export default function chapterRequest(book, chapter) {
  const addr = "http://localhost:3000/kjv_bible/api/kjv_bible";
  const bibleRoot = document.querySelector("#bible-root");
  fetch(`${addr}/${book}/${chapter}`)
    .then(response => response.json())
    .then(response => {
      bibleRoot.innerHTML = `<h2>${response.book_name}</h2>` + response.info_html;
      bibleRoot.appendChild(renderChapterNavigation(
        response.previous_chapter, response.next_chapter
      ));
    })
    .catch(error => {
      bibleRoot.innerHTML = `<p>${error.message}</p>`;
    })
}

function renderChapterNavigation(prevResp, nextResp) {
  const chapNav = document.createElement("div");
  chapNav.className = "chapter-nav";
  chapNav.appendChild(chapterNavigation({
    idBtn: "prevBtn", idSpn: "prevSpan",
    clk: () => chapterRequest(prevResp.book_name, prevResp.chapter),
    txtBtn: `${prevResp.book_name} ${prevResp.chapter}`,
    txtSpn: "Previous Chapter"
  }));
  chapNav.appendChild(chapterNavigation({
    idBtn: "nextBtn", idSpn: "nextSpan",
    clk: () => chapterRequest(nextResp.book_name, nextResp.chapter),
    txtBtn: `${nextResp.book_name} ${nextResp.chapter}`,
    txtSpn: "Next Chapter"
  }));
  return chapNav;
}

function chapterNavigation(opts) {
  const prevNextNav = document.createElement("div");
  prevNextNav.className = "prev-next-nav";
  const btn = document.createElement("button");
  btn.id = opts.idBtn;
  btn.onclick = opts.clk;
  btn.textContent = `${opts.txtBtn}`;
  const spn = document.createElement("span");
  spn.id = opts.idSpn;
  spn.textContent = `${opts.txtSpn}`;
  prevNextNav.append(spn, btn);
  return prevNextNav;
}