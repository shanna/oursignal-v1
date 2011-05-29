insert into feeds (url, created_at, updated_at) values
  ('http://services.digg.com/2.0/story.getTopNews?type=json', now(), now()),
  ('http://www.reddit.com/.json', now(), now()),
  ('http://delicious.com/popular/', now(), now()),
  ('http://news.ycombinator.com', now(), now());
