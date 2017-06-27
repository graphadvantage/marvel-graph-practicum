WITH "file:///[PATH TO DIRECTORY]/marvel-graph-practicum/marvel_characters.csv" AS url
CALL apoc.load.csv(url,{header:true}) YIELD map
WITH apoc.map.clean(map,[],[""]) AS m
CREATE (n:Character {character_id: m.id}) SET
n.name = m.name,
n.description = replace(replace(replace(replace(m.description,'<p class="Body">',''),'</p>',''),'â€™',"'"),'&hellip;','...'),
n.image_url = m.thumbnail,
n.series = m.series,
n.comics = m.comics,
n.events = m.events,
n.stories = m.stories


...if only there were a function to covert JSON lists to properties
n.characters = CASE WHEN m.characters <> "[]" THEN apoc.convert.fromJsonList(m.characters,'.name') ELSE NULL END


..I wonder how long these strings are?
http://gateway.marvel.com/v1/public/series/
http://gateway.marvel.com/v1/public/comics/
http://gateway.marvel.com/v1/public/characters/
