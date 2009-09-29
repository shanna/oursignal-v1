backend backend_apache {
  .host = "localhost";
  .port = "8080";
}

backend backend_merb {
  .host = "localhost";
  .port = "4000";
}

sub vcl_recv {
  if (req.http.host ~ ".local$") {
    set req.backend = backend_merb;
  }
  elsif (req.http.host ~ ".com$") {
    set req.backend = backend_apache;
  }
  else {
    error 404 "Unknown virtual host.";
  }

  # Browsers send this shit way too often.
  if (req.http.Pragma ~ "no-cache" || req.http.Cache-Control ~ "no-cache" || req.http.Cache-Control ~ "private") {
    unset req.http.Pragma;
    unset req.http.Cache-Control;
  }

  # Only send cookies to pages requiring authentication.
  if (req.http.host !~ "^staging." && req.url !~ "^/(signup|login|users)") {
    unset req.http.Cache-Control;
    unset req.http.Cookie;
    unset req.http.Pragma;
  }

  # The default vcl is used from here.
}

sub vcl_fetch {
  # Explicitly cache.
  if (obj.http.Cache-Control ~ "max-age") {
    unset obj.http.Set-Cookie;
  }

  # Force caching regardless of headers.
  if (req.url ~ "^/(stylesheets|javascripts|themes|i|static)/") {
    # Try to encourage browsers by setting Cache-Control headers as well.
    set obj.http.Cache-Control = "public,max-age=3600";
    set obj.ttl = 1h;
    deliver;
  }

  # Cache links for 5 minutes.
  if (req.http.host !~ "^staging." && req.url !~ "^/(signup|login|users)") {
    # Don't encourage browsers to cache for now. I don't have a message explaining that'll have to force refresh to
    # see feed changes after you make them.
    # set obj.http.Cache-Control = "public,max-age=300";
    set obj.ttl = 5m;
    deliver;
  }

  # The default vcl is used from here.
}

