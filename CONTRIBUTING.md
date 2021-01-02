# Welcome

We invite you to join our team! Everyone is welcome to contribute code via pull requests, to file issues on GitHub.

## Getting Started

<details>

<summary>
<h3 style="display:inline;">Set it up locally!</h3>
</summary>

### Fork it

You can get your own fork/copy of this project by using the <kbd>Fork</kbd> button.

![Fork Button](https://help.github.com/assets/images/help/repository/fork_button.jpg)

### Clone it

You need to clone (download) it to local machine using

```sh
$ git clone https://github.com/<YOUR_USERNAME>/Companion-App.git
```

Once you have cloned the repository, move to that folder first using `cd` command.

```sh
$ cd Companion-App
```

Move to this folder for all other commands.

### Set it up

Run the following commands to see that _your local copy_ has a reference to _your forked remote repository_ in Github :octocat:

```sh
$ git remote -v
origin  https://github.com/<YOUR_USERNAME>/Companion-App.git (fetch)
origin  https://github.com/<YOUR_USERNAME>/Companion-App.git (push)
```

Now, lets add a reference to the original [Companion-App](https://github.com/GfG-JSSATEB/Companion-App) repository using

```sh
$ git remote add upstream https://github.com/GfG-JSSATEB/Companion-App.git
```

> This adds a new remote named **_upstream_**.

Verify the changes using

```sh
$ git remote -v
origin    https://github.com/<YOUR_USERNAME>/Companion-App.git (fetch)
origin    https://github.com/<YOUR_USERNAME>/Companion-App.git (push)
upstream  https://github.com/GfG-JSSATEB/Companion-App.git (fetch)
upstream  https://github.com/GfG-JSSATEB/Companion-App.git (push)
```

### Sync it

**Always keep your local copy of repository updated with the original repository.**

Before making any changes and/or in an appropriate interval, run the following commands _carefully_ to update your local repository.

```sh
# Fetch all remote repositories and delete any deleted remote branches
$ git fetch --all --prune

# Switch to `main` branch
$ git checkout main

# Reset local `main` branch to match `upstream` repository's `main` branch
$ git reset --hard upstream/main

# Push changes to your forked `Companion-App` repo
$ git push origin
```

### You're Ready to Go

Once you have completed these steps, you are ready to start contributing or raise [Issues](https://github.com/GfG-JSSATEB/Companion-App/issues) and creating [pull requests](https://github.com/GfG-JSSATEB/Companion-App/pulls).

</details>

---

<details>
<summary>
<h3 style="display:inline;">Installation</h3>
</summary>

Make sure you have following installed on your machine:

-   [Flutter SDK](https://flutter.dev/docs/get-started/install)
-   [Android Studio](https://developer.android.com/studio) or [VSCode](https://code.visualstudio.com/download)

To setup Flutter in Android Studio check [here](https://flutter.dev/docs/development/tools/android-studio)

To setup Flutter in VSCode check [here](https://flutter.dev/docs/development/tools/vs-code)

-   Install flutter dependencies using:

```sh
$ flutter pub get
```

-   Setup Firebase(Only Android for now): For more details check [here](https://firebase.google.com/docs/flutter/setup?platform=android)

-   Install firebase tools:

```sh
$ npm install -g firebase-tools
```

-   Install cloud function's dependencies using:

```sh
$ cd functions
$ npm install
$ cd ..
```

Run the app using:

```sh
$ flutter run
```

Upload firebase functions:

```sh
$ firebase deploy --only functions
```

</details>

---

### Create a new branch

Whenever you are going to make contribution. Please create separate branch using the command and keep your `main` branch clean and most stable version of your project (i.e. synced with remote branch).

```sh
# It will create a new branch with name <YOUR GITHUB USERNAME>/<ISSUE NUMBER> and switch to that branch
$ git checkout -b <YOUR GITHUB USERNAME>/<ISSUE NUMBER>
#Example
#$ git checkout -b monatheoctocat/1
```

Create a separate branch for contribution and try to use same name of branch as of your contributing feature associated with your assigned issue.

To switch to desired branch

```sh
# To switch from one branch to other
$ git checkout <BRANCH NAME>
```

To add the changes to the branch. Use

```sh
# To add all files to branch <YOUR GITHUB USERNAME>/<ISSUE NUMBER>
$ git add .
```

Type in a message relevant for code using

```sh
# This message get associated with all files you have changed
$ git commit -m '<relevant message>'
```

Now, Push your awesome work to your remote repository using

```sh
# To push your work to your remote repository
$ git push -u origin <BRANCH NAME>
#Example
#$ git push -u origin <YOUR GITHUB USERNAME>/<ISSUE NUMBER>
```

Finally, go to your repository in browser and click on `compare and pull requests`.

<h4>NOTE:</h4>

**_Make sure you make Pull Request from your branch to the `development` branch of our project_**

Then add a title and description to your pull request that explains your precious effort.
Don't forget to mention the issue number you are working on.

### Thank you for your contribution.
