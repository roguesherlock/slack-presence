# SlackPresence

```
Slack Presence -- send messages as you in your slack workspace

usage:
  ./slack_presence msg

opts:
  --channel -> slack channel to send msg on
  --token -> slack token to use
  --set-status -> set status. msg should have the following format: "status_text status_emoji"
  --set-presence -> set presence. msg would be the presence text. msg could be either "auto" or "away"

Note:
  You can also, set channel and token in the SLACK_CHANNEL, SLACK_AUTH_TOKEN envs respectively
  prefrence order for the channel and token is
  args > envs
)
```

## Installation

- [Create an Slack App](https://api.slack.com/apps)

- App should have following scopes: [chat:write:user](https://api.slack.com/scopes/chat:write:user), [users:profile:write](https://api.slack.com/scopes/users.profile:write), [users:write](https://api.slack.com/scopes/users:write) to post message, set status and set presence respectively

- Install the App

- Get the OAuth Access Token from the `OAuth & Permissions` tab in your app page.

- Finally, Set the `SLACK_CHANNEL` and `SLACK_AUTH_TOKEN` envs respectively

- Lastly, test your settings by executing `./slack_presence what's a computer`


## Integration with SleepWatcher

So you can integrate it with sleepwatcher to automatically set the status when
you're away.

- Install sleepwatcher. `brew install sleepwatcher` (having trouble installing sleepwatcher? See [Trouble?](#trouble))

- put the commands you want to execute when you're sleep or wake up in `~/.sleep`, `~/.wakeup` respectively. They must be executable.

- Start the sleepwatcher daemon. `brew services start sleepwatcher`

If you want to be fancy you can run commands when dispaly dims/un-dims. Edit
`/usr/local/opt/sleepwatcher/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist`

Here's what my file looks like:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>de.bernhard-baehr.sleepwatcher</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/sbin/sleepwatcher</string>
		<string>-V</string>
		<string>-D ~/.sleep</string>
		<string>-E ~/.wakeup</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
</dict>
</plist>
```

Now, stop and start sleepwatcher service again `brew services stop sleepwatcher; and brew services start
sleepwatcher`


Lastly, See here to get the idea of `sleep` and `wakeup` scripts
- [sleep](https://github.com/roguesherlock/dotfiles/blob/macOS/scripts/sleepwatcher/going_to_sleep.fish)
- [wakeup](https://github.com/roguesherlock/dotfiles/blob/macOS/scripts/sleepwatcher/waking_from_sleep.fish)


## Note for Developers

If you want to edit the app, you can just modify the files and run `mix
escript.build` build the app again.


## Author's Note

I created this app because I didn't want to post message to slack channel every
time I'm afk. So, I use this to post status messages to `#status` channel and
set the status for every time I put my computer to sleep or wake up 🙃. Hope
it's useful to you in some way 🙂


## Trouble?

### `/usr/local/sbin is not writable.`

Usually this error occurs because High Sierra by default no longer creates this
directory. Here's a simple way to fix it.

```
sudo mkdir /usr/local/sbin
sudo chown -R (whoami):admin /usr/local/sbin
```

Now, you can link sleepwatcher by executing

`brew link sleepwatcher`



## P.S.

- All shell commands mentioned here are for [fish shell](https://fishshell.com).
