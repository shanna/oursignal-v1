backend backend_apache {
  .host = "localhost";
  .port = "8080";
}

backend backend_merb {
  .host = "localhost";
  .port = "4000";
}

acl acl_stateless {
  "localhost";
  "203.206.182.106"; # Office.
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

  # On top of basic auth at the apache level block outside IP's from staging.
  if (req.http.host ~ "^staging." && !client.ip ~ acl_stateless) {
    error 403 "Forbidden.";
  }

  # Browsers send this shit way too often.
  if (req.http.Pragma ~ "no-cache" || req.http.Cache-Control ~ "no-cache" || req.http.Cache-Control ~ "private") {
    unset req.http.Pragma;
    unset req.http.Cache-Control;
  }

  # Force caching on static stuff.
  if (req.url ~ "^/(stylesheets|javascripts|themes|images|static)/") {
    unset req.http.Cookie;
    unset req.http.Pragma;
    unset req.http.Cache-Control;
    lookup;
  }

  # Only send cookies to pages requiring authentication.
  if (
    req.url !~ "^/(signup|login)" &&
    req.url !~ "^/[a-z0-9][a-z0-9]+/(logout|edit|feeds|update)"
  ) {
    unset req.http.Pragma;
    unset req.http.Cache-Control;
    unset req.http.Cookie;
  }

  # The default vcl is used from here.
}

sub vcl_fetch {
  # Force caching regardless of headers.
  if (req.url ~ "^/(stylesheets|javascripts|themes|images|static)/") {
    # Try to encourage browsers by setting Cache-Control headers as well.
    set obj.http.Cache-Control = "max-age=3600";
    set obj.ttl = 1h;
    deliver;
  }

  # Explicitly cache.
  if (obj.http.Cache-Control ~ "max-age") {
    unset obj.http.Set-Cookie;
    deliver;
  }

  # The default vcl is used from here.
}

