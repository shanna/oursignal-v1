alter table links
  rename score_googlebuzz to score_google
;

alter table links
  drop score_frequency
;

alter table scores
  rename score_googlebuzz to score_google
;

alter table scores
  drop score_freshness,
  drop score_frequency,
  drop velocity
;
