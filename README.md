# marvel-graph-practicum
Advanced Neo4j Developer Practicum

### Welcome to the Neo4j Marvel Universe Practicum!

You will use a combination of tools to load data, design a schema and deploy a full stack reporting application.

### Getting started:

1. Make sure you have Anaconda3, Yarn, Node.js and the APOC tools installed.
2. Learn how to use http://www.apcjones.com/arrows/# for designing your graph schema.
3. Create a new database in your neo4j.conf file called **marvel.db** and start Neo4j.  Don't forget to configure apoc to allow file import...
4. Clone the Neo4j Browser https://github.com/neo4j/neo4j-browser, following the directions, and start it running with Yarn (in a new terminal window) on http://localhost:8080.  Then replace the init.coffee script with the version from here: https://github.com/graphadvantage/neo4j-browser-images , and then restart Yarn. Follow the directions to connect to Neo4j.
5. Get a Marvel Developer Account and your public and private API keys (test them to make sure they work) https://developer.marvel.com/

![marvel_portal](https://user-images.githubusercontent.com/5991751/27566224-a175211e-5a98-11e7-9194-57bdf8aaf7d4.png)



### Exercise 1: CSV files from JSON

1. From the Anaconda3 Navigator launch Jupyter, and then navigate to this project from localhost:8888.
2. Open the "Marvel Universe Practicum" notebook.
3. Enter your public and private API keys in the appropriate spots, and also update the directory path for your csv files.
4. Run each of the cells, and if all goes well you will have three new csv files (marvel_characters.csv, marvel_comics.csv, marvel_series.csv)
5. Open the file called marvel-build.cyp, and run the first statement after you update the directory path.

You will now have some Character nodes in your graph.  If you navigate to http://localhost:8080, you should see something like this:

![neo4j_browser_images](https://user-images.githubusercontent.com/5991751/27593214-6e3466ca-5b0b-11e7-86a9-01857f588065.png)



### Exercise 2: Inspect CSVs & schema Design

1. Write a query using apoc or LOAD CSV to inspect the other CSVs
2. Think about how you would model this data - what are the entities?  relationships?
3. Open http://www.apcjones.com/arrows/# and start sketching out your schema.  Identify your unique ids for each entity.



### Exercise 3: Fire up the Marvel app
1. In a new terminal window, navigate to this project
2. Install the requirements and start the app:

```
$ pip install -r requirements.txt
$ python marvel.py
```

Open a browser window and go to http://localhost:8088  You should see something like this:

![marvel_app](https://user-images.githubusercontent.com/5991751/27566158-210814be-5a98-11e7-9521-fdab1afb62b7.png)

Play around with this a bit, and then take a look at the marvel.py code and the index.html code in /static

You'll see that there are two endpoints specified

http://localhost:8088/?search=spider

and

http://localhost:8088/character/1011426

You can see how each endpoint uses a Cypher statement, and that the results for each statement are serialized for presentment.  Study this pattern, we'll use it later.

You'll also see that clicking on a row in the search results invokes a function targeting the /character endpoint, passing the character_id as a singleton query to Neo4j, and returning some stats and an image.

If you play around with this, you'll see some improvements that can be made...

3. Those pesky null descriptions.  Modify the cypher query for the search endpoint to handle these better. How you do it is up to you.



### Exercise 4:  Application security

You've probably noticed that we are using the Bolt driver - with default admin credentials. Yikes!

1. Create a Neo4j reader role, and rewrite the connection string to use this role.
2. Test it.



### Exercise 5:  Load the rest of the data

1. Write load queries for the marvel_comics.csv and marvel_series.csv to make Comic and Series nodes.
2. Inspect your results - notice anything interesting?  Images? Garbage? What about those Json lists?
3. Rewrite your queries to parse the Json lists into useable property arrays for name and resourceURI
4. Throw in a CASE statement to avoid writing blank arrays
5. Add a uniqueness constraint on each of the id fields for each of the three nodes.
6. Write a query that searches (Character {name: }) for a particular value. Note the response time. Do something to this node to make searches go faster. Note the new response time.

### Exercise 6: Refactor nodes
1. Notice that there is a list of Creators in the Comic node.
2. Refactor this to a new Creator node


### Exercise 7:  Refactor relationships

So now you have a bunch of nodes - but how are they related?

1. Update your schema diagram with your new thinking.
2. Write cypher statements to set relationships using the Neo4 browser interface.
3. Delete all these relationships and
4. Write cypher statements to set relationships using Bolt and python: https://github.com/graphadvantage/python-neo4j-bolt-test



### Exercise 8: Database backup

1. Once you've finalized your updates, make a backup of your database using the Neo4j admin tool
2. Verify that you can restore the database from this backup

### Exercise 9: Data dump and high speed import
1. Use the apoc export CSV tool to create CSV exports for your nodes and relationships
2. Use the Neo4j Import tool to these files to a new database


### Exercise 10: Some analytics

So now you have graph - let's see what's in it!

1. What are the top 10 Characters by appearances in Comics?
2. What are the top 5 Series by number of Comics, and how many Comics do they have?
3. Which are the 3 Series with the earliest endYears, and how many unique and shared characters do they have?
4. Which Character has the highest page rank?
5. If there is extra data you'd like from the API to further enrich your graph feel free to write a routine to grab it.  You can use apoc or modify the Jupyter scripts. I've provided some sample JSON for you to check out, and here's a hint:

```
WITH "Iron%20Man" AS character,
timestamp() AS ts,
"MY_PRIVATE_KEY" AS privateKey,
"MY_PUBLIC_KEY" AS publicKey
WITH character,ts,privateKey,publicKey,apoc.util.md5([ts,privateKey,publicKey]) AS hash
WITH ts,publicKey,hash,"https://gateway.marvel.com:443/v1/public/characters?name="+character+"&ts="+ ts+"&apikey="+publicKey+"&hash="+hash AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.data.results as map
RETURN map
```


### Exercise 11:  Application API enhancements

1. Write/update endpoints for retrieving some comics and series for a specific character
2. Enhance the application to pull through details, including images for comics and series
3. Render these in the Character panel
.. there are some commented-out code snippets that might be helpful for serializing arrays...


### Excercise 12: Make it great!

Anything goes - seems like it would be cool to search by a Series and get the characters that appeared in that series... in a new page perhaps? Characters who know each other? Creator summary? Or maybe something else entirely?  Do your best hacking, and we'll put it up for a class vote!  
