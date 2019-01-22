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


## Note for Developers

If you want to edit the app, you can just modify the files and run `mix
escript.build` build the app again.


## Author's Note

I created this app because I didn't want to post message to slack channel every
time I'm afk. So, I use this to post status messages to `#status` channel and
set the status for every time I put my computer to sleep or wake up 🙃. Hope
it's useful to you in some way 🙂
