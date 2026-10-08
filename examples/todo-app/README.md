# Todo App

A to-do list for one person that runs in the browser, keeps tasks on your device, and needs no account. [PROJECT.md](PROJECT.md) explains why it exists.

## How to run it

Todo App is deployed on Cloudflare Pages. Open it in any current browser on a phone or a laptop, and add your first task. Tasks are saved in that browser on that device, so clearing the site's data deletes them.

### Back up your list

Select **Export** to download your list as a JSON file. To restore it, select **Import** and choose the file. Import replaces the list on this device after you confirm.

### Run it locally

The app is static files with no build step. Serve the project folder and open it in a browser:

```sh
python3 -m http.server 8000
```

Then open `http://localhost:8000`.
