# TG2-Legacy

Download link : https://github.com/Vire7777/TG2-Legacy/archive/master.zip

In Progress
- If attacking building and someone attacks you. Character keeps throwing torch (dumb)
- Watched thug attack bank and guard just stood there watching
- Officesession vote draw should go to current officeholder
- Dynasty AI are voting against own dynasty in officesesstion
- Waylay issues
- Watch tower balancing
- [Add] Patron and peasants can become quaksalver and try selling magic beans (if you have a farm)
- [Add] Religion wars
- [Add] You can bounty hunt people in mercenary camp
- [Add] If you accuse for witchcraft, you can be burned instead
- [Add] If you accuse for witchcraft, you can become a blacksheep if the priest think you are a lier
- [Add] In Important person book, can find the guild masters and the alderman (only after their election from day 1-2)
- [Remake] Remake of the contamined system, now you can have different impacts at the same time (like perfume AND blacksheep) 
- [Fixed] When a preacher with a church and sending money to cardinals, we receive a strange message after (The messages are corrected in the script to have the good message sent. Also code is rewrote to be clearer)
- [Fixed] Hedge tavern girl assigned to dance always stops dancing and needs to be reassigned
- [Fixed] Assassin outlaw text is fixed
- [Fixed] Can not ride a horse if not owned a castle (country estate or more) or you have to pay
- [Fixed] No entry for court date in journal. Judge always no shows
- [Fixed] Accuse Witch broken (weird)
- [Fixed] Pest house bugs -- can attack all building except state
- [Fixed] Mead not working -- no bug but added experience reward

Fixes Provided in Legacy 2.02
- Possible hospital bug where workers are going to hospital when not sick [Finished] <---Needs testing. Mostly Vanilla code should be fixed.
- Fix Tutorial #6 - Power & influence [Finished]
- Add XP for scholars, craftmen & patrons as they work [Finished]
- Remove "Talk" measure from officesessions and trials [Finished]
- Fix arsenal error where button does not show up to purchase troops for war (need this to gain imperial fame and advance in nobility) [Finished]
- Remove extra mill worker [Finished]
- The Pirate's Nest in building requirements it shows some string. Also some names are displayed wrongly when placed on the map (building rank 2 and 3) [Finished]
- Fix AI Hijacking bug (AI permanently frozen in this measure) [Finished]
- [Fixed] Possible bug: Mills spamming inside cities [Finished]
- [Fixed] Pirate ships that are not hidden love to stop moving every two meters [Finished]
- [Fixed] Fishermen boats stuck in attack mode (possibly caused by watchtowers) [Finished]
- [False Bug] Cannot repair ships [Not A Bug] <---Repairing ships is different from repairing carts. Ships must be in home building and if you click on the ship itself you will see a repair button.
- Remove children from street fights [Finished]
- Fix Cohabit bug where partner trapped in house for long periods of time waiting for spouse [Finished]
- AI Delay Timer now set appropriately based on Difficulty Settings [Finished]
- Pregnant women no longer confined to bed [Finished]
- Reduce Watchtower hitpoints [Finished]
- Waylay bugs fixes including wandering robbers, carts attempting to attack, loss of workers due to wandering [Finished]
- Extortion Bugfixes and tweaks including extortion spamming after refusal, no money payment, and changes to extortion income formula [Finished]
- Plunder building fixes including plunder message spamming and AI plundering building under construction [Finished]
- The prostitutes of the tavern are always flocking together, instead of staying where they have been assigned to [Finished] <---They stay put now and still bring in good income if placed intelligently
- Remove Office frequency option in MP (Causes crashes because host selection of this option does not apply to other players for some reason) [Finished]
- Disable Quicksave (Overwrites existing file which causes corruption) [Finished]
- Balance Training Experience Based On Years Per Turn [Finished]
- Fixed Bug in Trial.lua file [Finished]
- $3000 for a club (Check turnery prices) [Future Balance] <--- The club is an epic item will balance items in a later release
- Fix AI Host & Guests not showing up to feasts [Finished] <---This will need to be tested by Community. Watch for AI holding feasts regardless if you are invited or not and check functionality

Fixes Provided in Legacy 2.01
- Bugfix: player able to apply for office without required title [Finished]
- Fix children in offices and trials [Finished]
- Tweaked AI decision making. Rogues will attempt use blackmail (lowers disposition and is a crime) with their evidence, all other classes will go through trial process. [Finished]
- black boat textures. Probably has to do with half implementation of teleths mod [Finished]
- new nobility formula for trials <--- Accuser bonus - Accused bonus this way the accused gets a bonus as well if they are of sufficient status [Finished]
- Adjust charisma bonus. Adult Family Member Charisma Average with small bonuses for alliance's and non-aggression pacts. Added a small negative factor for enemies [Finished] 
- re-implement default messenger. [Finished]
- check latest patch and see if Quicksave feature is fixed. Possibly re-enable [Finished]
- AI Not using watch towers [Finished] 
- Fix state_fighting bug where player is attacking building while enemy knocks him unconscious [Finished]
- Fix state_scanning bug Watchtower bug where you can attack buildings and watchtower will let it happen. [Finished]
- When working in workshop player character will go back to working instead of completing desired measure [Finished]
- fix fishingboat bug. Can't fish for some reason. [Finished]
- find a position for towncrier that works on all maps [Finished] <----Like what he does now will compromise with more stationary time if needed
- Fixed a potential bug in officesession that may cause freezing. Without more information cannot be sure if it was indeed the bug reported [Finished]
- Text bug when selected guild master of a town [Finished]
- Compare
- Church production bug where production overrides other measures and main character does not complete tasks and just goes back to producing [Finished]
- Watchtowers can be destroyed again [Finished]
- Fix Idlelib.lua typo [Finished] <---Courtesy of [color=navy]Hardoraida[/color]
- Training has been set to last 24hrs [Finished] <---Requested by General Chaos
- AI far more active in the political scene [Finished]
- Fix AI rarely applying for new titles [Finished]
- Remove 6th worker from fishing hut [Finished] 
- Fix Children AI initiating diplomatic relations [Finished]
- Leftover bugs from previous versions which disabled attacking buildings. Need to re-add recently sabotaged impacts and modify strength of sabotage and fire damage & spread factors [Finished]
- Test grog in rogue tavern. Prices are wonky and no one seems to buy it. Also changed quantity to received to reflect stealth value rather then arcane knowledge. The higher your stealth the more grog or rum you will get with your purchase[Finished] <---Must move into sales inventory, buy all improvements, assign server and dancer and people buy.
- Bancharacter AIFunction error in logfile [Finished]
- Fix Feasts [Finished]
- Kill highjacked not working [Finished]
- Fix arrest loop bug [Finished]
- Fix illegal Detection error where allied units will not jump in and help if you have bribed the guards or control city guards [Finished]
- Fix Cities not upgrading [Finished] <---- By year 1456 (4yrs per turn) Hansa was Imperial City. Not sure how quickly it happened but it did happen so good enough! London also leveled up

Fixes Provided in Legacy 2.0 Port
- All-in-one port to Patch 4.211
- Huge emphasis on fixing Vanilla broken AI scripts. The game is bustling now with AI activity exactly the way ALL the different Dev teams had envisioned
- Intelligent Office AI. (AI family members will not run against each other and if there is an empty office position above them they will apply for it. Offices will stay full!)
- Buildings can be attacked again (Previously disabled by earlier legacy versions)
- Fixed vanilla bug where if you are attacking buildings and were attacked you would still attack buildings instead of attacker (all allied units in vicintiy will come to defend you and you will now defend yourself)
- Rewrote many of my own broken scripts.
- Teleths mod is only partially implemented now (This happened during debugging. Might re-add in future version)
- Many many fixes & tweaks included over the course of three months. Cannot remember them all

Fixes Provided in Hotfix Version 1.163
- Fixed empty political tree bug
- Removed Trial Restrictions (You can charge again as often as you want and when you want)
- Fixed Feast not ending bug (Prevented you from being able to change your primary residence)
- Removed Teleportation Scripting <---Your characters will no longer teleport all over the map (No point refining this code as it should not be needed anymore once once official patch is released)

Fixes Provided in Version 1.16
- Fixed AI hospital bugs {Finished} <---AI should run hospitals better and only refuse patients that are enemies. Your workers should keep healing patients as well...hopefully
- AI will not accuse anyone until after 11pm. This gives players one hour to accuse before the AI {Finished} <---Players have trial priority now
- Fix cities leveling up too fast due to more worker slots {Finished}
- Fix AI Residence Bug {Finished} <---Exempt AI dynasties and Residence owners from Nobility title Restrictions
- Fix bug where AI helper automatically turns itself back on {Finished}
- Implement war fix found on Nordic games site by picqua {Finished}
- Increase Detected Distance for Arsenal during prewar for button so its not so finicky to show up  {Finished}
- Add exemptions to teleport fix based on measures {Finished} <----Scout building, Burgle House, Waylay, pickpocket
- Increase/decrease chance of AI Sovereign stealing from treasury based on disposition {Finished} <----Also lower disposition if caught
- Decrease chance of AI Sovereign stealing from treasury based on disposition {Finished} <----Also lower disposition if caught
- Attempt to get AI to use the Character Assassination measure {Finished - Not Tested}  <---- This has nothing to do with killing, it allows a dynasty to attach false crimes to a targeted sim founded on rumor
- Increased Harbour Range when building warehouses for ships {Finished} <----Cannot find post of person who showed me the fix but thank you sir very much
- Create Measure for Townhall To show list of top 5 candidates for next pope {Finished} <---Button only visible when Imperial City is Present. May have to set a property in citylevel.lua
- Create Measure for Townhall To show list of top 5 candidates for next emperor/king {Finished} <---Button only visible when Imperial City is Present. May have to set a property in citylevel.lua
- Fixed Max Cost For Trial Bug (Max trial cost is now set at $5000)
- Manual heal button in the hospital that gives you the option to treat and get money for healing an enemy that is lingering inside your hospital (refused by the autoheal measure) {Finished-Zbombe}
- Increased the chance of illness based on weather {Finished - Zbombe}
- Bankers also keep working now (Player fix only I think, we still need to write scripts for AI unless they are hardcoded...not 100% sure as I just browsed the files) {Finished - Zbombe}
- Fixed some german text errors {Finished - Zbombe}
- Fixed bug where AI are entering "unenterable" buildings and I am assuming getting stuck {Finished-Zbombe}
- Disabled Warninghorn sound as infinite looping is in the sourcecode and made appropriate changes to makeevocation.lua where sound is also used
- Add description for Herbal tea, soap, blanket in text.dbt (if you have these items in your residence there is a chance that one will disappear. When this happens the use of the item prevented your from becoming ill) <----Almost no one knows of this hidden gem so it definitely needs to be added into the text :) {Finished-Napi96}

Fixes Provided in Version 1.15
- Add Forged Epic Items 2.0 by And0r {Finished}
- Inquisition bugfix where same religion causes your character to loose all abilities and remain arrested {Finished} <---Dunstan Isolated Bug and provided working fix :)
- Bugfix where AI dynasties were charging their own members {Finished} 
- Bugfix where clicking the hurry to court button while pregnant caused character to loose all measure {Finished} <---this is fixed for trials, officesessions, feasts and duels as well
- DarkLiz updated her Sit Around/Drinking Buddy Mod {Finished}
- Fixed bugs related to Stone top (would not play animating and missing buttons) {Finished} <--- Dunstan provided fix for animation bug
- Added Hair & Hat-Mod by Fajeth {Finished} <---- You can choose from ALL hats and hairs for all professions

Fixes Provided in Version 1.14
- Make Blackdeath contagious again {Finished}
- Fix Sales ban {Finished}
- Fix waylaying {Finished} <---All files are back to vanilla so if it worked before it should work again also modified teleport code to not include carts since spinning carts are not detectable as an error
- Fix Watchtowers so they always come to your aid in a fight {Finished} <----For some reason before it was inconsistent :P
- Fix Late Game AI Applying for only high-end offices {Finished} <----Will need more testing by community to fine tune number adjustments
- Fix children performing adult measures and having adult measures performed on them [fighting,pickpocketed..ect]  (they are cancelling schooling and apprenticeships) {Finished} <---Attack and pickpocket are all I found...Duels already have a min age filter
- Reputation gain when you become Emperor, King or Pope {Finished} <---Personal & Imperial Fame
- Fires are more out of control ESPECIALLY in the Summer time! If you use last two hardest settings building can raze to the ground. Becareful when using firebombs to sabotage...the whole city might catch fire {Finished}
- Cannot harvest Wheat, Barley, or Fruit in the winter time {Finished} <----Main character will finish collecting if he was set to harvest in the fall but will stop after he places goods in inventory

Fixes Provided in Version 1.13
- Fix Game Freezing after 5 or more turns at 3am {Finished}
- Add Legacy Version Number to Loading Screens {Finished}
- Add graphics mod by Broliii (female fix) {Finished}
- Actual cost to apply is halved but is showing full price in-game for offices {Finished} <--Text is hardcoded which means no arithmetic can be performed on OfficeGetChargeCost function. Result of this fix means office application costs a whole lot more (but the paycheck is still worth it)
- Fixed lower council service error that resulted in an error message when sim attempted to apply for office. {Finished}
- Remove AI ability to remove people from office (we want offices full) {Finished}
- Add impacts for excommunication (cannot be excommunicated again for 10 rounds) {Finished} <---Made this global...you are already just excommunicated seems dumb you are excommunicated again a year after :P
- Add Impacts for Emperor Punish & King Punish (5 rounds for AI Emperors and Kings [keep targeting same people]) {Finished}
- Setup formula for AI mayor when setting taxes (right now its random and generates a lot of hate) {Finished}
- Fix sims applying for multiple offices (hard because function "SimIsApplied" returns true if someone challenges his office) {Finished}
- Fix AI only applying for upper tier offices late game. (recreate office check for AI based on title {Finished} <---AI applications are based on title. Higher titles can apply to higher offices but the lower titles can still occupy high offices if they start at the bottom :)
- Add message for church owners if they received money from those donating to the council of cardinals {Finished} <---message will be removed when Head of the Council of Cardinals office is created. Money will go to that person instead..
- See if it is possible to fix text for kids cancelling apprenticeship {Finished Not Tested}
- Secret Mixture Fix {Finished}
- if quick sentence is carried out by judge then cancel the trial on the building (might have to temp disable quick sentence if I cannot figure out how to cancel trial from building) {Finished Not Tested}
- Fix random people not in courthouse but locked in trial (Stop behavior instead of switching it to Idle) {Finished - Needs more testing}
- fix people making it into courtroom but get stuck until trial is over (lock rooms and building first thing) {Finished - Needs more testing}

Fixes Provided in Version 1.12
- Fix Monetary Bugs in CommandMe Mod & Eliminated the useless files {Finished}
- Fix AI seemingly frozen randomly around the map {Finished}
- Re-add the commandme mod {Finished}
- Fix AI Loitering in front of townhall {Finished}
- Fix AI not applying for office {Finished}
- AI wasting their time and trying to charge someone at the wrong time {Finished} <---there may be some occurrences where this happens because they do not make it to the courthouse on time but it is greatly reduced
- Bugfix where tavern owners were magically gaining $300 everytime they danced in their own taverns {Finished}
- Bugfix where tavern owners were magically gaining $300 everytime the bathed with someone or alone {Finished}

Fixes Provided in Version 1.11
- Added Embezzle Money Failure [Politics mod] {Finished} <---Rewrote the fail code to be much more realistic and modified the text slightly
- Political Tree Bugs (Emperor & Pope are for life, Sovereign may apply for King, elected pope emperor or king is selected from the imperial city {Finished}
- Spinning Carts & Stuck Sims Bugfix (this will also fix waylay and any other bugs associated with sims randomly teleporting while performing a task) {Finished}
- Fix Ships not being able to attack {Finished}
- Slightly decrease population required to trigger Imperial City {Finished}
- Sims spamming attack measure (possible CTD associated with this bug) {Finished Not Tested}
- See if temporary fix for AI lurching when assassinated is possible {Finished} <----If part of a dynasty, AI or Human, They will be removed from that dynasty. This is hardcoded and hoping for a source code fix from the devs. The zombie state has been removed and they should perform Shadow AI measures until a safe time has been reached for them to die. This is the best I can do.
- Fix possible pneumonia epidemic {Finished Not Tested}
- Fix Bug where you cannot use snaplock gun {Finished}
- Fixed market error caused by me not porting gunsmith mod correctly {Finished}
- Fix AI Divehouse measures {Finished}
- See if I can find & alter Item demand for coins & sleeping spindels {Finished}
- Crusade Bugs {Finished}
- Fix Feast Measure {Finished} <---Everything now works correctly as intended. The formulas are much more accurate and have been simplified so that future endeavors to expand this measure are possible. Vanilla AI auto refused feast invitations if your relations were below 30%. I rewrote this so that if you spent enough money on your feast everyone will come (who could refuse great food and great music?). This will be your non-violent way to successfully end feuds and will greatly improve your chances of getting the office position you want!
- Get AI to accuse more often {Finished Not Tested} 
- Check out politics mod and incorporate any fixes <--- OfficeSession bugs (text errors, session not starting, members in the room but message saying they are not) {Finished Not Tested}

Fixes Provided in Version 1.10
- Fix captured judge teleporting to office/trial meetings {Finished}
- Attack bug fix where a group of henchmen join fight one at a time (all will join at same time now) {Finished}
- Distract the Guards feature working {Finished}
- fixed repopulate mod. AI was not auto-equiping or using AI measures like assassin or witch burning {Finished}
- Attempted to fix AI ability to marry into Human dynasty. Causes player to lose control of their own dynasty member in singleplayer and can cause OoS in MP game {Finished}
- External Charisma Bonus to help prevent failing relations {Finished}
- Canon towers only detect illegal actions against own dynasty (currently they attack everyone) {Finished}
- Disable auto-plunder for Humans when opponent refuses to accept protection from extortion {Finished}
- AI can now call the guards if you try to extort protection money (This will result in worker spending time in the pillory) {Finished}
- Disable auto-sabotage for humans if Opponent calls the guards when your worker is trying to extort protection money {Finished}
- Disable auto-kill on prisoners who are in player controlled thieves guilds and opponent has called the guards {Finished}
- Reduced punishment when the guards are called on thief trying to collect a ransom from death to time in the pillory (AI will still kill your family member if you call the guards on them) {Finished}
- The Title Text for Emperor, King and Pope magically disappeared somehow and has been re-included in the next version {Finished}
- Fix trial bug that causes a judge that no longer holds his office to still preside over a trial (only one trial booked at a time! And only a small window between 22:00 - 02:00 you can book a trial :P) {Finished}
- Animals being accused BugFix (Not sure if this happens often but I added a check for this) {Finished}
- Sleeping spindel bugfix (A simple fix...The code was pointing to the wrong state) {Finished}
- If you become an Outlaw Guards will now hunt you down like a dog and if they manage to get you unconscious they will murder you on the spot (custom work around that fixes the PENALTY_FUGITIVE code) {Finished}
- Fix Curse Building Measure {Finished}
- Fix Hex (curse) documents are working correctly! {Finished}
- If you applied for an office position but were automatically selected to become emperor, king or pope then remove the office application (What happens now is you become Emperor, King or pope but lose the title if you are voted into the office position you applied for {Finished}
- Only those living in Imperial Cities can become Emperor, King or Pope (Hopefully fixes bugs associated with Imperial Office sessions) {Finished} <---Simply purchase or build house in Imperial City and don't forget to assign as home building :)
- If a tie occurs during office election then the original office holder retains his seat {Finished}
- More text fixes (fixed messed up message if you were banned, changed caries to tooth rot, and a few other fixes that disappeared from earlier versions) {Finished - for now :P}
- Modified Office Voting bonus's (Slightly increased local club president bonus, Added flat bonus for Noble Birth, Added a multiplier bonus for title <---this will require you be much more aware of who you are running against!) {Finished} 
- Attempted a fix to prevent AI from walking out of courtdates. Also fixed a couple related bugs to do with sleeping spindel and hypnosis I found (AI with these states will not be teleported to trials) {Finished}
- OoS Work arounds for known errors {Finished For Next Version...But Will Remain Vigilant...}
- Ported Tortured Hijacked Mod for Thieves Guild {Finished}
- fixed Kill Hijacked Measure {Finished}
- Fixed Script error in state_verflucht.la {Finished}
- Fixed Script error in burgleahouse.lua <--- In AI files {Finished}
- Removed the ability to attack with numerous characters. This causes "join one at a time" bug. Move all your characters to the area of fight or future fight and attack with one character. The rest will join AT THE SAME TIME {Finished}
- Noticeable changes based on the Difficulty settings you choose. (This will affect AI Actions, Money, Favor) 

Fixes Provided in Version 1.09
- Partially Removed MapPacks (MP stability and pathfinding should improve)
- Fixed missing guild clerk & Guild elders
- Fixed Guild Clerk & Guild Elders dying (fix provided by sefer)
- Can once again buy alderman chain and other class specific goodies 

Fixes & Content Provided in Version 1.08
- Added Gunsmith & Piracy Mod by Teleth
- Added MapPacks
- Fixed Ban Character measure
- Fixed Musician script error
- Slightly refined pathfinding teleport fix (Tons of teleporting on MapPacks maps...they may not be playable)
This is testing for MP Stability...Please report ALL findings

Fixes Provided in Version 1.07
- Script error in trial.lua fixed
- Last attack filters altered to prevent AI from attacking buildings (if error persists hardcode issues)
- banker having kidnapping measure fixed and moved to main character w/2nd level thieves guild
- Fixed added measures for main character (All three sabotage measures)
- Outlaw script bug I created in 1.06 fixed
- Outlaw text.dbt spelling error fixed
- Possibly fixed the error allowing you to marry other Dynasty members resulting in you losing control of the married character (should not have the ablitity to target main character dynasty members anymore but this is not tested)


Fixes Provided in Version 1.06
- Completely went through the entire Repopulate folder and eliminated all the bugs
- Added new outlaw measures by Sunpack and Eliminated all the bugs
- Went through and found some suspicious OoS code (Using LocalPlayer) and removed it
- Increased the money for the dice game
- fixed all reported bugs (Too many to list hahahaha) <---Hoping the gamebreaking ones are gone!!!
- Changed the prerequisite to sabotage watchtowers to simply combustible firebomb (Was too lazy to create its own entry in the building upgrade file mostly because I cannot create a new picture for it...my skills are lacking in that department)
- The repopulate mod is initiated automatically but a button will show up at townhall allowing you to turn off the more difficult features (recommend leaving it on)
- Pregnancy is 9 months regardless of what year per turn setting you choose (4 years per turn is 4 times faster then 1 year per turn)
- Buildings at the start of game all have owners now (still are for sale and can be purchased)
- 

Fixes Provided in Version 1.05
- New button allowing your henchmen to attack watchtowers (Requires three residence upgrades: Combustible bomb, Guild of Artisens, Guild of Rogue) <---purchased in buildng improvements
- If building is renovating and your henchmen sabotages the building then the building will stop renovation
- Fixed School bug
- Created whole new school system for AI
- AI who own hospitals will gain doctorate title
- Fixed some Logfile spam (more still remain...weeding out all the errors will be a very long process)

Fixes Provided in version 1.04
- German Version
- Watch Towers are more useful (try them out)
- Pathfinding teleport for stuck objects (Not final but better then test version)
- Disabled logging and sync logger in blind hope that some OoS's were caused by these features
- Fixed as many AI measure spams as I could including removing the AI's ability to go to school...this needs to be balanced in future version (ran out of time)
- Hospital workers perform duties 24hrs a day because of how fast illness's progress
- Miners and lumberjacks now work 24hrs a day as well and have the ability to fight so they can defend their workplace (Obviously those guys would be pretty tough in them days)
- Reduced years2master times in all professions...some professions will master quite fast (Bonus to weaker professions)
- Disabled "H" toggle in-game which caused all your icons to disappear (Probably for screenshots but most likely would be pressed accidentally and cause panic)

Fixes Provided in version 1.03
- Added FT&M ver 1.4 all credits to General Chaos, DarkLiz, and Fajeth
- Reduced assassinations and witch burning frequency
- No assassinations or burning occur within the first 5 turns
- Only those who have titles can assassinate or be assassinated or burned (Hopefully this means only dynasty members now...not workers)
- Crimes committed while commanding the city guard can now expire to prevent punishment
- number of crimes committed while commanding city guard before receiving punishment has been increased
- Fixed some Alias errors found in the logfiles (repopulate.lua)
- Main character can kidnap, demand ransom, use bombs & firebombs.
- Pickpocketing is no longer detectible by guards but is theft and can now be used in court if witnessed
- Capturing buildings is now reverted back to hitpoints, this is possible because I have decreased damage done by bombs and removed their cooldown



Fixes Provided In Hotfix Version 1.08
- Found and fixed further error with apprenticeship/university/school
- Found and fixed Alias error
*This is last hotfix for at least 6 days. Was hoping to fix banking system but will have to set aside a day to test different functions and blocks of code. Its not a quick fix.


Fixes Provided In Hotfix Version 1.07
- Reversed attend and attending school/apprenticeship/university interrupt values in measures.dbt to prevent error spam in logfile (Go attend is now lower value then already attending...it was reverse before)
- Increased interrupt values of attend and attending school/university/apprenticeship
- Added property so that AI kids are only offered to attend school/university/apprenticeship once
- Added impact to dynastyIdle.lua so that it is only ever called a maximum of once per hour on each sim

Fixes Provided In Hotfix Version 1.06
- Compile Error Created by me <-- had a blonde moment :D
- Numerous Alias Errors Added 50+ "if AliasExists" checks :P

Fixes Provided In Hotfix Version 1.05
- Removed bailiffs from the game. Added more CityGuards (tried to regulate bailiffs numbers and failed so opted to remove them all together)
- Adjusted damage done to buildings when sabotaging (still high but building shouldn't burn down on the first attempt)
- Increased detection by the guards when sabotaging buildings (capturing buildings was too easy)
- Replaced Kinvers presession.lua file with vanilla in hopes it stabilzes OoS issues being reported just prior to office sessions commencing
- Made an attempt to prevent OoS's during trials and Officesessions (only testing will confirm if I succeeded)
- Almost positive I have eliminated the last traces of AI attacking buildings (mesh bug causes OoS errors in MP games) 
*Are the major gamebreaking bugs gone? Let me know by reporting any you might find :)

Fixes Provided In Hotfix Version 1.04

- Witch buring and assassinations can be turned off by pressing cancel AIHelper button. All bug fixes will remain on automatically.
- New button when you click on an unowned building. Pressing it will automatically find an owner if there is one suitable
- Removed Two trial per year mod. Trials are causing OoS errors so the less there are the better. 
- Removed the trial cutscene as a MP stability test. If OoS's still occur near trials then I will enable them again
- Adjusted loops in Attend Church and Arrest measure in hopes of stabilizing OoS errors
- Increased the faith received for attending church. (I found it to be very tedious to maintain a high faith)
- Moved Give Money, Donate, And quick political bribe from the guildhouse to the bank where they are supposed to be
* Intuitive installer provided by jonaswashe!  

Fixes Provided In Hotfix Version 1.03

- Fixed Text.dbt CTD bug associated with title loss (hopefully this cures the ctd associated with trials)
- Fixed numerous bugs in REB mod (logfile looks a lot cleaner)
- Fixed last script error in vanilla (hopefully )
- GREATLY reduced assassinations and witch burning. <--- Less then one killing per turn in my tests. 
^^Quick Tip: Favor does NOT matter. The code looks at who you are enemies with in your important persons list. Use residence to negotiate with your enemies into a NEUTRAL agreement pact. Emperor, King and pope punishments ALL work the same so make sure they stay out of your enemy list 
- Fixed punishment in the balancing of my "Become the law" mod <--- changed worker punishment from outlaw to execution
- Fixed AI attacking buildings. This should NOT happen anymore <---adjustments made in two files...


Fixes Provided In Hotfix Version 1.02

- Removed "Price Option When Selling Building" mod in hopes that vanilla files will solve MP OoS issue
- Fixed BlackDeath.lua file properly this time <--- Hopefully fixes MP OoS issue
- Fixed AddPamphlet.lua (Tested and works GREAT ) <---Hopefully fixes MP OoS issue
- Fixed TrainCharacter.lua <---You can train again without becoming an outlaw  (I use traincharacter as a test file so it was a complete accident and apologize for the inconvenience )
- Fixed a few text errors
- Made a couple more tweaks to files to help prevent MP OoS


Fixes Provided In Hotfix Version 1.01
IMPORTANT: Game Mechanics Changed In Order To Fix CTD Issue! Please read 
Here Is A LINK To A Comment Made By FH Who Is The Main Programmer/Scripter for The Guild 2 - Renaissance about the Game Mechanic Changes We Made
- Can no longer Attack Buildings due to CTD mesh bug linked with Orchard & Farm Buildings.
- Capture building has been modified. A building must have been recently sabotaged in order to capture. If guards are too close you cannot capture building (error message will pop up)
- Since you can no longer attack buildings the damage caused by sabotaging a building has been greatly increased 
- Changed the AI script from attacking buildings to sabotage them instead
- Fixed Multiple Script Errors found in posted logfiles
- Assassinate and Burn Witch AI scripts have been rewritten and players should be less likely to die
- New measure added to keep track of faith percentage of main characters (75% and above keeps you safe from burning)
- Fixed outlaw bug...again  (hopefully third times a charm )
- Changed outlaw sentence in KingPunish and EmperorPunish to time in the Pillory   (This fixes a bug)
- Fixed buy nobility title error (can now click on townhall without your character being in building and purchase a nobility title) <---this worked in vanilla, it was remnants of Fajeth mod pack I accidentally added, forgot to test and never removed  


Fixes Provided In Hotfix Version 1

- Fixed Script Error causing Oos in Blackdeath.lua
- invite to dance, take a bath and items.dbt files all back to vanilla (no bugs)
- Outlaw Fixes for missing a trial, imperial punish, royal punish and consequence for killing judge <--- Apparently outlaw bug was NEVER fixed in Vanilla. Entries in trial.lua had to be added as well as Action.dbt needed to be tweaked. This is sad because I had it fixed in a mod before PotES even existed let alone Venice or Renaissance 
- Can now capture buildings that do not have owners


Current Version 1.02

- Added REB Mod created by Kinver  <---fixed numerous bugs and removed certain files incompatible with Legacy mod
- Added check for Lavender and Wheat at marketplace...if it reaches 9999 it should be fixed within one turn
- Fixed numerous Vanilla script errors (Hopefully OoS causing ones)
- Rebalanced CityLevel.lua <---Should level up properly now
- Fixed GoToSleep Measure. Added 12hr impact timer so that it is not called repeatedly on same Sim
- Probably other things I cannot remember...


Fixes Provided in Version 1.01

- AI now uses all new measures introduced in Legacy mod pack
- Fixed AI feast invite script error
- Attempted to fix OoS issues (Not Tested - I Need Testers Willing To Play Long MP Games Repeatedly. If OoS occurs post logfiles IMMEDIATELY before starting new game) 
- Fixed empty offices bug
- Fixed text error in Excommunication measure
- Altered Attend doctor measure and added helper for AI medics (Shouldn't get error message when sick and enough inventory should be able to treat patients)
- Fixed many issues in Repopulate measure
- Added Worker list from Fajeth mod pack (sorted by level & age) 
- Removed List measure and moved Pope candidate list into proper place


Description:

* Repopulate - AI Helper
- On/Off button. This is the most important file in the game and should be Initiated By first clicking on townhall and then the Repopulate button on townhall at the start of the game. 
- Financial Assistance. AI only get a certain amount of money based on number of family members. Spam cheat not possible. (turns off if you press cancel repopulate button) 
- AI Random titles. Mathematically set up to resemble real-life. Most should have lower titles, however it is theoretically possible to have it reversed. Very unlikely though. Lump sum of Money is given to reflect the title
- AI Auto-upgrade their equipment in this file over time (This shuts off when file is turned off)
- Gives AI a child if they have a low amount of family members (Can be turned off)
- This file also trigger countless AI Actions so they use measures and abilities.  (Once turned on it cannot be shut-off. The checks continue automatically)
    --AutoAI uses (King Measures, Pope Measures, Emperor Measures, Poison Well, Cardinal Favor)
- Burn Witch <---AI use this but it can now be turned off when you press the cancel AI Helper button 
- Assassinate <---AI use this but it can now be turned off when you press the cancel AI Helper button 
[Idea By: Atrox (repopulate) & General Chaos (AI ArmourUpgrade) & The Entire Guild 2 Community (Intelligent AI) Created By: McCoy!]

* REB - Economy Mod
- Balanced Economy
- Bank Profession fixes
- Kinver's REB Mod Thread: LINK
[Idea By: kinver Created By: kinver Bugfixes By: McCoy!]

* Bribe The Guards
- Slip some coins to the right office member and the guards may ignore your foul deeds for a little while. This version has been tweaked. Bribe success depends on the officeholders disposition (the one who controls the town guards). Make sure to check out his disposition before bribing. If his disposition is high then bribing a higher amount is highly recommended as there is now a consequence for refusal 
[Idea By: McCoy!, Created By: McCoy!]

* Trial Fixes 
- Message fixes 
- also turns off trial cutscene (hopefully this helps stabilize mp games) <---also adds to difficulty because you no longer know what the judge or assessors are thinking
[Idea By: chip007 Created By: chip007]

* Give Money
- Go to a bank you to give a % of your money to another sim. Especially useful in MP games with noobs 
[Idea By: Kaliandr Created By: McCoy!]

* Raise Disposition 
- Sick of being a walking nightmare? Now you can literally bribe the entire city to improve your disposition. People simply refuse to believe the rumors of your atrocities...after all a person who gives a complete stranger money for no reason can't be all that bad. Simply go to a bank and you will have the option to give your townsfolk some money
[Idea By: McCoy! Created By: InsaneKaos & McCoy!]

* Hire an Assassin
- Want someone dead without the need to get your hands dirty ? Go to a tavern or hedge tavern between midnight and 02:00am and hire yourself an assassin. Remember that the more distinguished the target the more it will cost (takes into account title and office)
- Targets with low disposition are 10% of the normal cost.
- Tavern Owner gets 10% cut of what you pay...if you own the tavern think of it as a 10% discount
[Idea By: McCoy! Created By: McCoy!]

* Quick Political Bribe 
- Is the office member you want to bribe busy or in a distant town right now? Simply go to a bank and you will have the option to deposit some money into their account (system works exactly the same as if you bribed them normally)
[Idea By: McCoy! Created By: McCoy! & InsaneKaos]

* Call The Guards I & II
- Was an old or useless dynasty member kidnapped and now some thief is demanding a ransom? Now you have the option to call the guards and watch the thief lose his head. This will result in your dynasty members death as well but used in the right circumstances who cares!?!
- Are you sick and tired of Robbers always trying to extort protection money? Now when they do this you have the option to call the guards...this will result in the robber trying to sabotage your home. If you have henchmen nearby they will try to stop him or if the guards are nearby they will stop him. However even if he succeeds the cost to renovate your home will still be less then paying for their protection. Also when the guards catch the robber you will get to see him do some time in the pillory
[Idea By: Jeriah Created By: McCoy!]

* Accuse men of Heresy or women of witchcraft 
- Another way to kill without getting your hands dirty. Pay the church enough money and you can accuse a man or woman of witchcraft and see her burn. You cannot accuse Fanatics. You cannot accuse anyone who is currently in a different town (it would take too long for the sequence of events to complete). Simply go into a church and you will see the new Burn A Witch button  
- Targets with sufficiently low faith are 10% of the cost. You get dinged if you want to falsely accuse someone. However if your target's faith is too high accusation is not possibe. Church owner gets 10% of the cost
[Idea By: Aragornil Created By: McCoy!]

* Increase severity of justice 
- Justice is even more harsh when Judge sets it to Severe. There is a downside...your empathy skills will be permanently affected. -3 for setting it to severe +1 if you set it to lenient. 
NOTE: The empathy skills only affect the judge who changed the severity
[Idea By: Aragornil Created By: McCoy!]

* Option for longer banishment time 
- When banishing someone you now have to option to pay money in order to make their banishment time longer. The more distinguished the target is the more the added banishment time will cost. You still have the default banishment option that costs no money
[Idea By: Aragornil Created By: McCoy!]

* Prevent cheat that allows player to capture and sell same building continuously. 
- Bug: Capture building then sell it only to recapture it again. Repeating this process numerous times results in quite a bit of cash depending on the building and whats in the inventory. 
- Feature: Now you cannot sell a captured building for a certain amount of time (works like a recently burgled building)
[Idea By: McCoy! Created By: McCoy!]

* Harsh consequences for Attacking/killing Judge involved in a trial or an Accuser
- Avoiding an outlaw sentence used to be easy if you killed the accuser or judge. This is pretty much prevented with this mod. Attacking either will draw the guards and if you successfully kill either one then there will be serious consequences...(spy theme has been incorporated into the text to make these consequences flow with the game)
[Idea By: McCoy! Created By: McCoy!]

* More Challenging Bribing System
- Default 2.2 bribing system is based on a targets wealth + office. 
- More Challenging Bribing System adds and extra cost onto a dynasties title (makes it so players try other items found at the marketplace to help out their cause)
[Idea By: Determinado Created By: McCoy!]

* The New Sections Added To Important Persons Tab (Workers sorted by level & age and Pope Candidates) 
- If there are no PopeCandidates no list will show up - To get yourself on that list you must go inside a church with your character and click on a council of cardinals button and donate money
- Unemployed Workers list sorted by Age & Level
[Idea By: thezirk & Nommy Created By: Nommy & McCoy!] 

* New Emperor & Pope Political Offices
- These new offices are only available in an Imperial/Capital City
- Two new offices added to the game...You cannot apply for the emperor office. The emperor is selected by money + wealth. You can also become the emperor by killing the emperor.
- King is auto selected but the sovereign can apply for the office. AI will apply too. Only the emperor votes the King into position
- If you are a Sovereign in another city you can quit remove yourself from office, assign this sim to residence in the imperial city and can apply for the office of King...
- If there are any candidates endorsed by the council of Cardinals the pope will be the one that has the highest level (5 levels of influence within the council). If more then one are the same level the winner is chosen randomly
- Council of cardinal button is visible when you enter a church. You have the option of donating money to the church to show your dedication to your faith. The contribution starts a $10,000 for the first level but escalates quickly to $1,000,000 for the 5th and final level
- Excommunication measure for pope. Target loses all faith (making them susceptible to burning) and All relations (Making them susceptible to assassinations) and all nobility titles, and 75% of their wealth just to add insult to injury 
- Papal Guard - Guard for the pope. They stay active a lot longer them the Royal Guard
- Pope can oust any religious office holder in ANY city...all favor is lost to that dynasty. This makes the player more susceptible to assassinations. 
- Emperor guard - Guard for the emperor. The guards stay active much longer then the papal guard
- Emperor can oust anyone in any city from office (Except church officials) with the consequence of losing favor...again player becomes more susceptible to assassinations
- Emperor Punish - Emperor can Tax, Execute, Outlaw, or imprison anyone one, once every 48hrs. The consequence is again low favor to dyanasty
- King Punish  Same as emperor punish EXCEPT that the target must have a somewhat low Disposition. (This is because the king is answerable to the Emperor) 
[Idea By: Napi96 & SunPack Created By: Sunpack & Napi96 Additional Content & Tweaks By: McCoy!]


* Misc 
- Diseases no longer claim last dynasty member (Exception is if two dynasty members get a fatal illness at the same time. However if you are already last sim then contract a fatal illness your sim will not die from it)
- BugFix: Diseases no longer affect certain professions (Inquistor, Executioner...ect) <---they get the disease but will NEVER die from it
- Money collected for extortion is based on building value
- Priests Gain Faith while preaching
- Become the Law mod has been balanced (If you abuse the office of Bailiff too much then at some point you will lose your office position and will have an active arrest warrant on you character)
- Political office voting system restructured
- Cannot apply for King unless you have held the position of Sovereign first. 
[Ideas By: LordProtektor & NekoIko & McCoy! Created By: LordProtektor & NekoIko & McCoy!]

___
Other Mods:
Gunsmith & Piracy v1.27 - The Guild 2: Renaissance
=================================================
I made the majority of this mod roughly a year ago but after having problems with the REB mod I gave up releasing it. 
In the past week or so, I've converted it to support the current McCoy fix pack with most of the other community fixes and also upgraded it a lot.

Gunsmith & Piracy now doesn't just return the Pirate haven to how it was in PoTES, it tries to re-imagine it as both a pirate bay and a gunpowder specialist for the rogue. 
Naturally it provides the rogue a better opportunity to arm him or herself with the latest in first-strike weaponry. Just what we needed! ::)

I've balanced this cross-class production so that it will be slightly more expensive to run, but suffers from less land-based competition. I don't think it will outperform a real smithy but provides the rogue with some 'semi-legal' opportunities to expand, as well as being able to actually improve trade economy rather than just destroy it.

Anyone is free to incorporate anything I have made, into their own mods should they wish to do so.

Installation
============
1. Install official patch 4.15
2. Install official patch 4.17b
3. Install McCoy's Legacy Mod 1.07
4. OPTIONAL - Install MappackEditionML 1.15 (Please note if you do not install the map pack, you will not be able to play the MapPack specific content, even if the menu shows these 3 maps.)

Extract Gunsmith & Piracy directly to your Renaissance directory after installing the above patches.
Allow it to overwrite any conflicting files.

If you wish to add additional mods I recommend using WinMerge or similar to resolve conflicts.

Main features
=============
The Pirates haven now has all three building levels, a new set of upgrades, and a gunsmith production chain.
The Hansa and Northsea maps have been hex-edited to have their pirate nests back for the AI!
Ships now have coloured flags and sails.
Carts can now supply other dynasties and not just your own dynasty via trade routes.
You can now use the free trade ability without upgrades to your house, regardless of your class.
Restores some of the older Guild 2 maps.
Plenty of bug and grammar fixes.
Rebalanced starting city randomizer.
Tweaks to remove the limitations of the storehouse.
A new level of mill and upgrades for it.

Gunsmithery
-----------
Pirate haven is now able to import/manufacture firearms and pistol munitions.

There are three new firearms in the game:
Early 1400s matchlock. 15 damage shot when entering combat. Unlocks for 600 gold with the level 1 Pirate's Haven.
Late 1400s wheellock. 30 damage shot when entering combat. Unlocks for 900 gold with the level 2 Pirate's Nest.
Early 1500s snaplock. 45 damage shot when entering combat. Unlocks for 1200 gold with a level 3 Pirate's Fortress.
The original matchlock can still be imported from the arsenal and deals 60 ranged damage + 15 melee.
All pistols require ammunition in your inventory. Ammunition is now also available from the marketplace.

Pirate haven
--------------
Pirate haven now costs 4000 for the first level but include a carrack vessel.
Pirate haven can now be upgraded to levels 2 and 3. Includes a new building upgrade scheme.
Pirate havens and their vessels can again be operated correctly by the AI.
The pirate haven can repair ships again.
Pirate havens now have a fully functional interior from the smithery interior.

General changelog
-----------------
A critical flaw prevented free trade from selling goods in certain scenarios, it has been fixed.
The carrack's stealth ability is now properly visible.
Ships now have a slightly larger firing arc.
Free trade now allows selling armor, weapons and consumables.
Increased pistol range slightly.
Pirate nests are now displayed on the minimap once again.
Pirate nest is no longer referred to as PirateHarbor.
There was an instance where an impact was not labelled "BeeingPlundered" as it should have been.
The Pirate nest was not correctly assigned to a profession.
Bank loans from the guild hall work correctly again.
The check faith button is now not visible during cutscenes, it has been altered to operate only when at church.
350 or so lines of text have had capitalisation, spelling and sentence structure re-arranged.
The free trade stall no longer appears and disappears during sales, it is also now active when selling from a cart.

1.01
-----
Added randomization of buildings on game start. No more cities full of foundries.
Several text fixes

1.02
-----
Workers were unable to enter Hansa and Northsea's initial pirate havens, resolved.

1.1
----
Storehouse no longer requires harbour.
Storehouse renamed to Storehouse Dock for clarification.
Storehouse can be placed on coast or in town, can repair ships.
Storehouse had its missing storage upgrades fixed.
City randomization is still in effect but is now balanced.
Fixed an old bug from PotES involving maps with few ships that made it possible to plunder fishing boats.
Restored the Sherwood Forest map (Late Newark).
Restored the Newark map (Early Sherwood).
Restored Nottingham (Early Sheriff of Nottingham).
Various Hansa map tweaks.

1.2
----
Pickpockets no longer try to get in one last attempt when dying.
Ranged combat now makes more thorough checking for dead combatants.
Fixed a script error that affected six different attack items for the AI.
Merged the croft and orchard. The orchard remains on maps with its previous abilities but it is no longer buildable.
The orchard in Lyon 3s was overlapping the mine and other buildings, it was moved to a sane location.
Wrote new crop sowing selection to account for fruit and honey.
Added a new level 1 Mill and replaced upgrade tree for both mills.
Fixed lack of mipmapping on the mill and orchard buildings.
Added a starting windmill to Hamburg on the Hansa map.
Fixed the level 3 gypsy's purple-infested icon.
Pirates nest level 1 had abnormally high base hitpoints.
Added gunsmith profession titles. Fruitlessly I might add.
Altered the title 'citizen without full rights' to 'lesser citizen'
Arrange a binge now has a cooldown of 4 hours rather than 1 hour. You now gain more XP for larger binges, 10% and 30% extra respectively.
All mercenary camps now cast shadows properly.
The level 1 mercenary camp had some decor added.
Dynasties that held an office in command of the guards would eventually amass crimes and could be punished repeatedly.
The pirates nest workers now look more pirate-like.
Fixed the unnamed counting house in the Tarry valley map.
Fixed _SCENARIO_LORD issue present on every MapPack map.
MapPack menu now reflects its 1.15 version.

1.21
----
Trial costs now displayed correctly.
Capture building text correction.
Hansa mill is now level 2 by default due to a cart problem.

1.22
----
Pickpockets and ranged combat now has additional checks for unconscious state.
Ammo now works correctly for players.

1.23
----
Updated for McCoy's Legacy 1.03

1.24
----
Updated for McCoy's Legacy 1.06

1.25
----
Ships should correctly be stunned temporarily after losing a cannon battle.
Ships now sink properly instead of just disappearing when destroyed.

1.26
----
Included the updated trial.lua file from McCoy's Legacy 1.06

1.27
----
Updated for McCoy's Legacy 1.07

Includes the following fixes merged from other authors
---------------------------------------------------------
Clothing items now convey the proper favor bonus when someone is within a certain radius of the wearer.
Toad slime now works as intended.
The market restocks certain items every hour at a reduced rate.
To account for increased wealth with McCoy's AI helper, ransom amounts for kidnapped persons is cut in half.
Drinking in a public house or pub (by using the sit measure) with other dynasty members will convey a favor bonus.
Alchemy/magic system has been expanded.
Horse carriages can be used more easily and is free of charge if you own an estate and purchase the stables.
You are prompted with a dialogue option before firing an employee.
Dr. Faust's elixir now has a chance to impact you negatively. 
Sleeping in taverns provides similar benefits to sleeping at home. Also provides faster sickness recovery.
Bathing alone adds a minor perfume favor buff, and also removes colds.

Thanks to McCoy, Fajeth, Darkliz and General Chaos for their efforts!

Known problems
==============
Higher level gunsmith workers will still be titled as serfs, the profession text seems hardcoded.
The Lyon 3s map has a defective field that AI cannot manage properly.
Ships may still circle the same spot endlessly as in vanilla, it is generally caused by high levels of time acceleration.
Scaffolding when building structures is still a mixed bag (not just for the pirate haven), I have not been able to correct these so far.
Pistol combat in general could use a re-work.
The second level of the Mill has a broken tooltip icon. I have yet to be able to find where this icon is located to edit it.
Orchard fields seem to have left over fencing from upgrading from the field.

- - - 


Misc. Fixes, Tweaks & Mods

--------------------------------------------------------------------------------
COMPATIBILITY:

This collection of mods is compatible with McCoy's legacy modpack v. 1.02 with hotfix 1.08.  
It requires The Guild 2: Renaissance updated to v. 4.17b.
The text.dbt file has been edited to work with all of these mods and 4.17b and McCoy's legacy modpack.  However, if you add additional mods that impact the text.dbt file you will need to tweak the file included here.

--------------------------------------------------------------------------------

CREDITS:

With the exception of the pregnancy, bath and go to sleep mods (originally created by Fajeth) and the ransom tweak and politics mod (created by General Chaos) all of these mods were created by DarkLiz.  A special thanks to her for help in figuring these out. Credit is due to LordProtektor, as I based some of the politics mod on his work. 

--------------------------------------------------------------------------------

OVERVIEW:

1. Clothing items now convey the proper favor bonus when someone is within a certain radius of the wearer.
2. Toad slime now works as intended.
3. The market restocks certain items every hour. 
4. To account for increased wealth with McCoy's AI helper, ransom amounts for kidnapped persons is cut in half.
5. Pregnant women can now walk around and perform actions while pregnant.
6. Drinking in a public house or pub (by using the sit measure) with other dynasty members will convey a favor bonus.
7. Alchemy/magic system has been expanded.
8. Horse carriages can be used more easily and free of charge with the proper house level.
9. You are prompted with a dialogue option before firing an employee.
10. AI sims should apply for offices more frequently and at higher levels now.  This was done by making the timer for repeating an application attempt lower for them, removing the restriction that shadow dynasty families could only have one member in office and run only if no other shadows were running, and reducing the favor threshold for application decisions from less than 40 to less than 95.  This means that an AI dynasty will run pretty much no matter what.  The AI can now also apply for office at any time except between 18 and 1 hours.  This means they can apply first thing in a new round, when they may be more likely to have money.  The price to apply for office has also been reduced.
11. Dr. Faust's elixer will now actually cause a negative affect when the message is given.
12. Sleeping gives a bonus to constitution and craftsmanship (even if you sleep in the inn).
12. Taking a bath alone (at the inn) will cure some diseases and increase favor with other sims you pass.
--------------------------------------------------------------------------------

INSTALLATION:

Copy the DB and Scripts folders in this package to the root directory of your Guild install and replace all files.


- - -
#####################################Others##########################################
This Mod is Re-Worked Renaissance balance.
And Include Bank fix Mod(loan system is Working).

Most of the focus on the economy and
Increased survival Chance for AI players
(Cuz that thing become to easy... sorry Human players :p)

And...
Some point is not matched "runeforge game studio" Balance way.
Just enjoy New-Game.

Moder: mousecat@lycos.co.kr

####################################Korean###########################################
???? ?? ??? ?? ??
? ??? ??? ???? ??? ??? ?? ?? ???.

??? ????? ??? ??
??? ???? ?? ?? ??? ??? ?? ???? ???? ??? ?? ??
??? ??? ?? ?? ?? ???? "??"? ???? ? ? ??? ??????.

???, ?? ???? ?? ?? ???? ???? ????.
4.15 -> 4.17 -> ? ??? ???? ?? ??? ??? ???? ??? ?? ? ????.

(*) = ??? ?? (Tested, Working)
(-) = ??? ? (Not tested)
(/) = ?? (block function)
(x) = Can't perfect repair BC API is have a Degine Error

==========================================v2.9==================================
[Support to Politics modification]
(*) ????? ??? ??? ?? ??? ???? ???? ?? ??? ???? ?????.
(*) ????? ??? ???? ??? ??? ?? ??? ??? ??? ??? ??? ???.

[AI]
(x) ??? ????? ????? ????? ?? ??? ??? ?? ???? ???. 
- ???? ??, ???? ??? ??? ?? ? ??
(*) ??? ?? ??? ??? ??? ??? ??? ?? ????
(*) ?? ? ?? ????? ?? ??? ?? ??? ??? ???? ???? ?? ?? ????? ??

[??]
(*) ??? ?? ???? ?? ??? ??? ?? ? ????? ??

[??]
(*) ?? ?? ? ??? ???? ???? ??? ?? ??

[??]
(*) ?? ??? ???? ???, ??? ??? ? ?? ?? ?? ??.

[??]
(*) ???? ?? ? ?? ??

[??]
(*) ?? ??? ??? ??? ??? ??? ??? ?? ????.

==========================================v2.8==================================
[Support to Politics modification]
(*) Politics modification? ?? ?? ???? ??? ?? ?? ?? ??

[AI]
(*) ??? ?? ?? ??? ??? ??? ??? ??? ?? ??
(*) ?? ?? ????? ?? ?? ??
(*) ?? ?? ???? ????? ??? ??? ?? ?????.
-?, ???????? ????? ??? ? ???? ???? ???? ???? ????? ????.

==========================================v2.7==================================
Renaissance v4.15? ? ?? ???? ????.

[AI]
(*) ???? ?? ????? ??? ???.
(-) NPC ??? ???? ???? ??? ??? ??? ?????.

[???]
(*) AI? ??? ??? ???? ???, ???? ????? ??? ???? ?? ??
-???, ???? ??? ??? ? ??

[??]
(*) ???? ???? ?? ?? ???????.
(*) AI??? ??? ??? ??? ???? ????? ?????.

[???]
(/) ?? ???? AI ????
- ??? 4.17 ???? ???? AI ??? ???? ??

[??]
(-) ???? ?? ??? ?????? ? ??

[????]
(*) ??? ???? ??? ????? ???? ???? ? ??
(*) ??? ??? ??? ?? ?? ??? ?? ?? (Mod Bug)
(*) ????? ??? ? ???? ??? ?? ??? ???? ?? ???. ?? ?? ???? ?? ?? ??? ?? ??? ???
- ?? ???? ?? ???? ?? ??? ??? ???? ????? ??? ??? ??? ????.

[????]
(*) "??? ???" ? ????? ?? ?? ?? ??? ? ???? ??? ?? ??? ???? ?? ???.
?? ?? ???? ?? ?? ??? ?? ??? ???
(*) "??? ???" ????? ??? ?? ??.
(*) ?? ??? ???? ??? ?? ???? ??? ??.
(*) ?? ??? ?????? ?? ?? ?? ??? ??? ??? ???? ????? ??? ??? ??

[???]
(-) ?? ???? ???? ????? ??? ??? ?? ? ??.
- ?, "??? ???"? ??, (? ???? ???? ? ???? ??? ????? ?,)
(*) ??? ??? ???? ??? ??? ??? ???.

[???]
(*) ??? ?? ?? 2?? ?? ??? ???? ????.
(*) ??? ?? ?? 2?? ?? ??? ???? ????.
(*) ??? ?? ?? 3?? ?? ??? ???? ????.
(*) ?? ??? ???? ?? ?? ??? ????.
(*) ?? ??? ???? ?? ? ????.
- ?, ??? ???? ??? ?? ??? ?? ?? ??? ??? ? ????.

[??]
(*) ??? ??/?? ?? ??.
(*) ??? ?? ??? ?? ??? ???? ??? ?? ??? ??? ???
(*) ?? "??" ???? ?? ??? ??? ?? ?? ??? ???
(/) ?? ????? ??? ??? ??? ???? ??.
- ?, ??? ?? ????? ????? ???? ???? ??? ??? ??
(*) ???? ??? ??? ??? ???? ??? ??? ???? ?? ? ?? 
(*) ???? 7Lv?? "??? ?"? ??? ?? ??? ??? ????? ????? ??
-?, ??? ?? ???? ?? ? ??? ?????? ? ??? ???? ??? ??? ??
??? ???? ??? ??
(*) ???? ??? ??? ?? ??? ?? ?? ?.
(*) ???? ???? ?? ?? ?? ??? ??? ?? ??? ??? ??? ?? ??.
(*) ???? ?? ?? ?? ?? ?? ??? ??
(*) ?? ???? ??? ??? ??? ???? ?????.
(*) ??? ???? ??? ??? ?? ???? ???? ?? ??? ??? ?? ????? ??? ????  ?????.
- ??, ?? ??? ?? ?? ???? ??? ????.

[Sim]
(*) ?? ??? ???? ??? ??? ??? ?? ???? ???? ??. 
- ??, ?? ?????? ???? ? ??? ???.
(-) ?? ???? ???? ??? ?? ?? ?? ?? ?? ?? ?? ??
- ????? ??, ?? ???, ??? ?? ???? ??,  ???? ???, ??...

==========================================v2.6==================================
[???]
(*) ???? ?? ????? ?? ??, ????? ?? ??, ??
- Frezz screen issue is sloved

[AI]
(-) ????, ?? AI? ??? ? ? ???

[???]
(*) ?? ??? ??? ??? ??? ??? ???? ????? ??

==========================================v2.5==================================
[??]
(*) AI? ?? ??? ?? ?? ??

==========================================v2.4==================================
[??]
(-) ??? ???? ??? ??? ?? ?? ??

==========================================v2.3==================================
[??]
(*) ?? ??? ??? ?? ???? ? ??? ??(???)? ?? ???? ? ? ??? ????.
- ???, ???? ?? ?? ??? ??? ??? ?? ????.
(*) ?? ??? ??? ???? ?? ???? ???? ??? ???? ?? ?????.

[??]
(*) ???? ???? ???? ?? ???? ??? ?? ??? ?????.

[????]
(*) ????? ??? ???? ???? ?? ??? ??? ?? ?? ?????.
(*) ??? ??? ??? ???? ???.

[??]
(*) ??? ??? ????? ? ? ?? ?? ??????.
??? ??? ??? ??? ?? ??? ? 1?? ?? ??? ??? ??? ????.
(*) ???? ?? ???????.

[????]
(*) ??? ???? ???? ? ??? ??? ?? ?? ???? ??? ??? ????? ???????.

[???]
(-) ????? ??? ??? ??? ??? ??? ???
(-) ????? ??? ????? ???????.

[Sim]
(*) ?? ??? ???? ??? ??? ??? ?? ??????.

[??]
(-) ???? ?? ???? ?? ?? ???? ??? ??? ???? ??? ?????.
(*) NPC?? ???? ?? ???? ?????.
- ??, ???? ?? ?? ?? ??? ??? ??? ??? ??? ???? ?????.
(*) ????? ???? ???? ???? ?? ??? ???????.
(*) AI? ??? ?? ???? ??????.

==========================================v2.2==================================
[Sim]
(*) ?? ?? ??? ???? ???? ??? ??? ?????.

[??]
(*) ?? ??? ??? ??? ?? ??? ???
???? ???? ??? ??? ??? ??? ???? ?? ???

(*) ??? ?? ???? ?, ??, ?? ? ?? ??? ??? ?? ??? ?? ??? ?? ???

[??]
(*) ???? ????? ????? ??? ?? ??? ???
- ??? ??? ??? ???? ??? ?? ??? ??? ??? ??? ??? ?? ??.
??? ???? ??? ???? ??? ??? ????

[???]
(*) ??, ??, ???? ?? ??
???? ???? ?? ??? ?? ????? ??? ?? ??? ???? ?????.
????? ???? ??? ?? ??? ???
??? ?? ????? ????? ?? ??? ???

[??]
(*) ??? ??? ? ?? ??? ???? ???? ???? ??? ?? ????? ?? ??? ?????.

==========================================v2.1==================================
[??]
(*) ?? ???? ??? ?? ???? ??? ??? ??? ?? ??
?) ?? ???? ????? ??, ?? ???? ??

[????]
(*) ?? ?? ??: ??? ? ??? ?? ??? ???? ? ?? ?? ??

==========================================v2.0==================================
[??]
(*) AI? ???? ?? ??? ?? ? ????. ?, ????? ?? ?? ????.

[???]
(*) ???? ?? ??? ?? ???????.
(*) ?? ??? ???? ??? ???? ?? ??? ???? ??????.

[??]
(*) ?? ??? ???? ?? ??? ?? ??? ?? ?????.

[??]
(-) ??? ??? ?? ??? ??? 9999? ??? ??? ???? ?? ????

==========================================v1.9==================================
[????]
(*) ????? ?????? ??? ????? ???? ?? ???? ??? ??

==========================================v1.8==================================
[??]
(-) ??? ??? ?? ??? ??? 9999? ??? ??? ???? ?? ????

==========================================v1.7==================================
[??]
(*) ?? ?? ??? ?? ??? ?? ???? ?? ??

==========================================v1.6==================================
[??]
(-) ??? ??? AI ?? ???? ?? [??? ???? ????? ??? ?? ??]
(*) ?? - ??? AI ??: ? ?? ??? ??? ??????

[??]
(-) ??? ??? ?? ??? ??? 9999? ??? ??? ???? ?? ????
(*) ???? ???? ?? ?? ??

==========================================v1.5==================================

[??]
(*) = AI?? ??? ?? ?? ?? ???? ???

[?? ??]
(*) = ? ??? ? ?? ??? ??? ???? ?? ??? ??? ?? ?? ????

[?? ??]
(*) = AI?? ??? ?? ?? ?? ???? ???
(*) = AI?? ??? ??, ??? ???? ??? ??
(*) = AI?? ??? ??? ?, ???? ??? ????? ??
(*) = ? ?? ?? ???? ????? ? ??? ?? ? ????? ??? ??? ?? ??
???? ??? 1? ??? ?? ??? ??? ?? ??-_- ?? ??? ?? ??.
?, ??? ??? ?? ???? ???? ???

[??]
(*) = ??? ???? ??? ??? ? ? ?? ??? ??
(-) ??? ??? ?? ??? ??? 9999? ??? ??? ???? ?? ????

==========================================v1.4==================================

[??]
(*) ?? ??? ? ?? ??? ??

[??]
(*) 4.15 ?? ?? (???, ????? ? ??? ?? ??)

==========================================v1.3==================================

??? ?? ??
[??]
(-) ??? ??? ?? ??? ??? 9999? ??? ??? ???? ?? ??

==========================================v1.2==================================

[??]

(*) ???? ?? ???? ?? ??? ??? ???-_- ???? ???
? ?? ??? ??? ?? ?? ??? ???? ?? ?????.

??? ??? ?? ?? ??? ?? ??? ?? ???.

 
[???]
(*) ???? ?? ??? ?? ?? ?????.

 
[??]
(*) ??? ???? ??? ???? ???? ??? ?????.

 
[???]
(*) ???? ???? ??? ?? ?????. ??? ??? ??? ?? ?? ????...
??? ???? ??? ???? ??? ???? ????? ??? ?? ??????.

==========================================v1.1===================================

[????]
(*) ? ??? ?? ?? ?? (?? ???? ??? ?~ ???), ?? ??? ??
(*) ???? ??, ?? ??? ??
(*) ? ??? 4? ??? ?? ??? ??? ??? ??? ???? ?? ?? ??
(???? 4????? ?? ??? ??? ?? ?? ??? ?? ???? ???? ??? ??? ???
?? ?? ???? ?? ???? ????? ? ??? ???? 3? ??? ??? ? ?? ??) 

[??]
(*) ?? ??? ?? ??, ??? ??? ??? ??? ??

[???]
(*) ???? ??, ?? ??
(*) ???? ?? ??? ??
(-) ??, ??? ? ??, ??, ??? ???, ??? ? ??, ??? ?? ?? ??? ????? ??? ???.
(*) ?? ??(? 70% ??? ??)? ?? ????, ???? ???? ??

[???]
(*) ??? ????, ???? ??? ??? ??
(*) ?? ??? ????

[????]
(*) ??? ? ??? ??? ??? ??
(*) ?? 1%? ??? ??? ?? ??? ?? ??
(*) ??? ???? ?? ??? ???? ??? ?? ??

[??]
(*) ????? ??? ???? ?? ?????. ?? ????? ???? ?????.
(*) ???? 10 ??? ??? ??? ?? ??? ??? ?????.
(*) ?? ???? ????? ???? ???? ?????.

[??]
(*) ???? ???? ??? ?? ??? ??? ???? ?? ??? ?? ??? ? ? ??
(*) ??, ? ? ?? ??? ??? ??? ???? ?? ??? ??? ?? ?
(*) ?? ?? / ???? ?? ??, ??? ??
(?? ??? ??? ?? ???)
