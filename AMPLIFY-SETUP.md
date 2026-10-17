# AWS Amplify setup

Amplify hosts your site. It watches your GitHub repo and rebuilds the site each time Claude pushes to `main`. You do this setup once, in your browser. It takes about 15 minutes.

## Before you start

- Your site is in a GitHub repo, and `main` is pushed. A private repo is fine.
- You have an AWS account. To make one, go to [aws.amazon.com](https://aws.amazon.com) and choose **Create an AWS account**. AWS asks for a payment card, even for the free tier.
- Optional but wise: in the AWS **Billing** console, create a budget of a few dollars with an email alert. Then a surprise bill cannot grow unnoticed.

## 1. Create the app

1. Sign in to the AWS console and open the [Amplify console](https://console.aws.amazon.com/amplify/).
2. Check the region at the top right. Pick one near you. The site is served worldwide either way.
3. On the **All apps** page, choose **Create new app**.
4. On **Start building with Amplify**, choose **GitHub**, then **Next**.
5. A GitHub window opens. Sign in to GitHub yourself, and allow AWS Amplify access. When GitHub asks which repos, choose **Only select repositories** and pick your site repo. Amplify sees nothing else.

## 2. Pick the repo and branch

1. On **Add repository branch**, select your site repo.
2. Select the branch `main`.
3. Choose **Next**.

## 3. Check the build settings

1. On **App settings**, Amplify finds the `amplify.yml` file in this repo. Leave it as it is. It runs `npm ci` and `npm run build`, and publishes the `dist` folder.
2. Do not add an Astro adapter. This site is static, so it needs none.
3. Choose **Next**.

## 4. Deploy

1. On **Review**, choose **Save and deploy**.
2. Wait 2 to 4 minutes. The build goes through Provision, Build and Deploy.
3. When it shows **Deployed**, open the link. It looks like `https://main.d1234abcd.amplifyapp.com`.

If the build fails, open the failed step and copy the log into Claude. Claude can read it and suggest a fix.

## 5. Tell Claude the live address

In Claude Code, say:

> My live URL is https://main.d1234abcd.amplifyapp.com

Claude writes it to `live_url` in `pipeline.config.json`. After each publish, Claude then checks that the change is live.

## 6. Use your own domain (optional)

1. Buy a domain from any registrar, or use Amazon Route 53.
2. In Amplify, open your app, then choose **Hosting → Custom domains → Add domain**.
3. Follow the steps. If your domain is in Route 53, Amplify sets up DNS for you. If not, Amplify shows the DNS records to add at your registrar. Amplify sets up HTTPS for you.
4. Wait for the domain to show **Available**. This can take from a few minutes to a few hours.
5. Tell Claude: "My live URL is now https://yourname.com". Claude updates `live_url`, and `site` in `astro.config.mjs`.

## What it costs

A personal site at normal traffic usually stays inside Amplify's free tier. A custom domain costs about $12 a year. Check the [Amplify pricing page](https://aws.amazon.com/amplify/pricing/) for current numbers.
