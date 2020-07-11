
export function parseIlliniboardRss(xmlDoc) {
  if (xmlDoc.hasChildNodes()) {
    let items = xmlDoc.getElementsByTagName('item');

    let articles = getArticles(items);

    return articles;
  }

  return null;
}

function getArticles(xmlArr) {
  let articles = [];

  for (var i in xmlArr) {
    let node = xmlArr[i];

    if (node.tagName === 'item') {
      let articleObj = {};

      articleObj.title = extractArticleProperty(node, 'title');
      articleObj.link = extractArticleProperty(node, 'link');
      articleObj.description = extractArticleProperty(node, 'description');
      articleObj.pubDate = extractArticleProperty(node, 'pubDate');

      articles.push(articleObj);
    }
  }

  return articles;
}

function extractArticleProperty(node, tag) {
  let prop = node.getElementsByTagName(tag)[0].childNodes[0];

  return prop.data;
}