# The Valley

A macOS adaptation of a ground-breaking real-time RPG from 1982

## History ##

The Valley was a type-in-yourself program published in the UK in *Computing Today* magazine’s April 1982 issue. I didn’t key it in but some other lad did, so I got to play it on the school’s Research Machines 380Z. The listing was guarded jealously, but I was able to borrow it, make a photocopy and, eventually, port it to the Dragon 32.

I wrote about in my ‘Forgotten Tech’ column in *The Register*, back in 2009. You can read the article [here](https://www.theregister.co.uk/2009/11/27/back_into_the_valley/). The [comments section](https://forums.theregister.co.uk/forum/1/2009/11/27/back_into_the_valley/) is particularly illuminting.

<p align="center"><img src="https://smittytone.github.io/images/valley_logo.png" width="800" ></p>

The column was prompted by the discovery of Fraser Charlon’s [Valley fan page](https://www.staff.ncl.ac.uk/fraser.charlton/otherstuff/Valley/valley_index.html). I got in touch with Fraser and he was kind enough to scan and email me a copy of the listing (mine had long since been dropped in the bin). Thus began an on-again-off-again project to create a macOS version that was true to the spirit of the original: a UI that mimicked the machine on which the game had been first presented (a Commodore Pet).

It was eventually done and played, but never fully debugged. I’d come back to it every once in a while, play it, tweak a few things, and get distracted by something else. Returning to the code in the Autumn of 2017, I decided that, once and for all, I would complete the code, bring the rest up to date, debug it and make it available to the world.

## Ownership ##

My code is architecturally quite different from the original, and operates in a very different way: it doesn’t run under a Basic interpreter in a single-task system, for starters. However, it uses the game design of the original and most of the original algorithms, so this is not all my own work. The original was written primarily by Peter Freebrey and Peter Green, with additional work by Henry Budgett, so the code in this repo is arguably as much theirs as mine. *Computing Today* was published by Argus Specialist Publications; as Argus employees, Freebrey, Green and Budgett wouldn’t have owned their work, their employer would. The magazine’s Publisher, Ron Harris, was also credited as a joint author; he managed the development project.

ASP’s parent company, Argus Press, sold the company in the mid-1990s, and it’s no longer clear who, if anyone, claims ownership of the original source code now. The same goes for the artwork included in the article, which I have used here. I also used it in the *Register* article, but no one stepped forward to claim it. I’d be happy to acknowledge them, if they did now.

My code also includes the Commodore Pet character set in three variations. Again, I use them in a spririt of fair use given their age and the certain lack of interest in such things by anyone of who might own Commodore’s assets today.

The macOS icon is based on The Valley’s iconic Dwarf and a swords-and-shield graphic by [PSD Graphics](http://psdgraphics.com).

Tony Smith<br>@smittytone
