backend backend_nginx {
  .host = "localhost";
  .port = "8080";
}

sub vcl_recv {
  set req.backend = backend_nginx;

  # Dont cache in development.
  if (req.http.host ~ ".local:\d+$" || req.http.host ~ ".local$" || req.http.host == "localhost") {
    return (pass);
  }

  # Only cache GET and HEAD by default;
  if (req.request != "GET" && req.request != "HEAD") {
    return (pass);
  }

  # Don't trust the outside world.
  if (
    req.http.Pragma ~ "no-cache" || req.http.Cache-Control ~ "no-cache" ||
    req.http.Cache-Control ~ "max-age=0" || req.http.Cache-Control ~ "private"
  ) {
    unset req.http.Pragma;
    unset req.http.Cache-Control;
  }

  return (lookup);
}

sub vcl_fetch {
  # Prefer cache-control to set-cookie, if you don't want to cache the page remove the
  # cache-control headers.
  if (beresp.http.Cache-Control ~ "max-age") {
    unset beresp.http.Set-Cookie;
  }

  # the default vcl is used from here.
}

