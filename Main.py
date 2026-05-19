import discord
import requests
from bs4 import BeautifulSoup
import asyncio
import os

TOKEN = os.getenv("TOKEN")

CHANNELS = {
    "mod": 1505501289428291694,
    "world": 1506270222103875624,
    "skin": 1505501292313710693,
    "texture": 1505578852355936317
}

intents = discord.Intents.default()
client = discord.Client(intents=intents)

posted = set()

print("🟣 BOT STARTED")


def safe_get(url):
    try:
        return requests.get(url, timeout=8, headers={"User-Agent": "Mozilla/5.0"})
    except:
        return None


def fetch_items():
    url = "https://dlc-1.vercel.app/"

    r = safe_get(url)
    if not r:
        print("❌ Site failed")
        return []

    soup = BeautifulSoup(r.text, "html.parser")

    items = []

    for a in soup.find_all("a"):
        title = a.text.strip()
        link = a.get("href")

        if not title or not link:
            continue

        if link.startswith("/"):
            link = "https://dlc-1.vercel.app" + link

        l = link.lower()

        if ("mediafire.com" in l or "gopro.com" in l) and link not in posted:
            posted.add(link)
            items.append((title, link))

    print("✅ ITEMS:", len(items))
    return items


async def loop():
    await client.wait_until_ready()

    print("🟢 LOOP STARTED")

    chans = {k: client.get_channel(v) for k, v in CHANNELS.items()}

    while not client.is_closed():
        items = fetch_items()

        for title, link in items:
            msg = f"🆕 **{title}**\n{link}"
            t = title.lower()

            try:
                if "mod" in t or "addon" in t:
                    await chans["mod"].send(msg)

                elif "world" in t:
                    await chans["world"].send(msg)

                elif "skin" in t:
                    await chans["skin"].send(msg)

                elif "texture" in t:
                    await chans["texture"].send(msg)

            except Exception as e:
                print("SEND ERROR:", e)

        await asyncio.sleep(900)


@client.event
async def on_ready():
    print(f"🤖 LOGGED IN AS {client.user}")
    client.loop.create_task(loop())


client.run(TOKEN)
