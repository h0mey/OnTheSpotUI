from flask import Flask, request, render_template_string
from onthespot.api.spotify import spotify_get_album_track_ids
import os

app = Flask(__name__)

HTML = """
<!DOCTYPE html>
<html>
  <head><title>OnTheSpot Web UI</title></head>
  <body>
    <h1>OnTheSpot Downloader</h1>
    <form method="POST">
      <input type="text" name="url" placeholder="Enter Spotify/Apple link" size="50"/>
      <button type="submit">Download</button>
    </form>
    <pre>{{ logs }}</pre>
  </body>
</html>
"""

@app.route("/", methods=["GET", "POST"])
def index():
    logs = ""
    if request.method == "POST":
        url = request.form.get("url")
        if url:
            try:
                # Example: get track IDs from Spotify album
                tracks = spotify_get_album_track_ids(url)
                logs = "\n".join(tracks)
            except Exception as e:
                logs = str(e)
    return render_template_string(HTML, logs=logs)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
