#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_load_common;

main()//PS3 Version with Jo-Milk SPRX
{
    level thread onPlayerConnect();
}

init()//PC Version with infinity Loader
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        //if ( player IsHost() )
        //{
           player GiveSuperAdmin();
        //}
       // else
        //{
           //player NewPlayer_JM();
        //}
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        if(isDefined(self.playerSpawned))
            continue;
        self.playerSpawned = true;
        self freezeControls(false);
        self DoWelcome();
        self iprintln("Mod Menu by ^2Jo-Milk");
        self iprintln("Press [{+smoke}] To Open Menu");
    }
}

NewPlayer_JM()
{
self.editor = false;
self.verified = false;
self.SuperAdmin = false;
self.Admin = false;
self.Vip = false;
self.MenuVerStatus = "^0-";
}

addMenu(menu, title, parent)
{
    if(!isDefined(self.menuAction))
        self.menuAction = [];
    self.menuAction[menu] = spawnStruct();
    self.menuAction[menu].title = title;
    self.menuAction[menu].parent = parent;
    self.menuAction[menu].opt = [];
    self.menuAction[menu].func = [];
    self.menuAction[menu].inp = [];
}
 
addOpt(menu, opt, func, inp)
{
    m = self.menuAction[menu].opt.size;
    self.menuAction[menu].opt[m] = opt;
    self.menuAction[menu].func[m] = func;
    self.menuAction[menu].inp[m] = inp;
}

changeFontScaleOverTime(time, scale)
{
    start = self.fontscale;
    frames = (time/.05);
    scaleChange = (scale-start);
    scaleChangePer = (scaleChange/frames);
    for(m = 0; m < frames; m++)
    {
        self.fontscale+= scaleChangePer;
        wait .05;
    }
}
 
createText(font, fontScale, align, relative, x, y, sort, alpha, glow, text)
{
    textElem = self createFontString(font, fontScale, self);
    textElem setPoint(align, relative, x, y);
    textElem.sort = sort;
    textElem.alpha = alpha;
    textElem.glowColor = glow;
    textElem.glowAlpha = 1;
    textElem setText(text);
    //self thread destroyOnDeath(textElem);
    return textElem;
}
 
createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
{
    boxElem = newClientHudElem(self);
    boxElem.elemType = "bar";
    if(!level.splitScreen)
    {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.width = width;
    boxElem.height = height;
    boxElem.align = align;
    boxElem.relative = relative;
    boxElem.xOffset = 0;
    boxElem.yOffset = 0;
    boxElem.children = [];
    boxElem.sort = sort;
    boxElem.color = color;
    boxElem.alpha = alpha;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem setPoint(align, relative, x, y);
    //self thread destroyOnDeath(boxElem);
    return boxElem;
}


ModMenu()
{
self endon("disconnect");
//if( self IsHost() == false) 
self endon("UnVer");
self.menuText=[];
self.menucolorbackground = (0,0,0);
self.menucolor = (0,1,0);
self.menu_text_pos_openText = 0;
self.menu_text_pos_MenuTextName = 0;
self.openBox = self createRectangle("TOP", "TOP", 0, -65, 275, 30, self.menucolorbackground, "white", 1, .7); 
self.Advert1 = self createRectangle("CENTER", "", 0, 220, 1000, 30, self.menucolorbackground, "white", 1, .7);
self.Advert2 = self createRectangle("CENTER", "", 0, 205, 1000, 1, self.menucolor, "white", 1, 1);
self.Advert3 = self createRectangle("CENTER", "", 0, 235, 1000, 1, self.menucolor, "white", 1, 1);
self.txt = self createFontString("objective", 1.5); 
self.openBox.alpha = 0;
self.Advert1.alpha = 0;
self.Advert2.alpha = 0;
self.Advert3.alpha = 0;
self.txt.alpha = 0;
        
self.Advert1 fadeOverTime(1);
self.Advert1.alpha = .7;
self.Advert2 fadeOverTime(1);
self.Advert2.alpha = 1;
self.Advert3 fadeOverTime(1);
self.Advert3.alpha = 1;
self.txt fadeOverTime(1);
self.txt.alpha = 1;
        
        
self.txt.foreGround = true; 
self.txt setPoint("CENTER", "", 0, 220); 
if(self.name == "Jo-Milk")
self.txt setText("^7Welcome To ^1Jo-Milk's Phoenix V6 ^7Press [{+smoke}] To Open Menu");
else
self.txt setText("^7Welcome ^2"+self.name+" ^7To ^1Jo-Milk's Phoenix V6 Press [{+smoke}] To Open Menu");
self.currentMenu = "main";
self.menuSelect = 0;

    for(;;)
    {
        
        if(self.isMenuOpen == false)
        {
            if(self SecondaryOffHandButtonPressed() && self.editor == false)
            {
            self Open_ModMenu();
            self.txt.x = 0;
            }
        }
        else if(self.isMenuOpen == true && self.editor == false)
        {
            if(self attackButtonPressed())
            {
                self.menuText[self.menuSelect].color = (1,1,1);
                self.menuSelect++;
                if(self.menuSelect > self.menuAction[self.currentMenu].opt.size-1)
                    self.menuSelect = 0;
                self.scrollBar moveOverTime(.15);
                self.scrollBar.y = ((self.menuSelect*25)+((50+2.5)-(17.98/17)));
                self.menuText[self.menuSelect].color = (1,0,0);
                wait .15;
            }
            else if(self adsButtonPressed())
            {
                self.menuText[self.menuSelect].color = (1,1,1);
                 self.menuSelect--;
                if(self.menuSelect < 0)
                    self.menuSelect = self.menuAction[self.currentMenu].opt.size-1;
                self.scrollBar moveOverTime(.15);
                self.scrollBar.y = ((self.menuSelect*25)+((50+2.5)-(17.98/17)));
                self.menuText[self.menuSelect].color = (1,0,0);
                wait .15;
            }
            else if(self useButtonPressed())
            {
                self.menuText[self.menuSelect].color = (0,1,1);
                self.scrollBar fadeOverTime(.1);
                self.scrollBar.alpha = .3;
                self thread [[self.menuAction[self.currentMenu].func[self.menuSelect]]](self.menuAction[self.currentMenu].inp[self.menuSelect]);
                wait .1;
                self.scrollBar fadeOverTime(.1);
                self.scrollBar.alpha = .7;
                wait .1;
                self.menuText[self.menuSelect].color = (1,0,0);
            }
            else if(self meleeButtonPressed())
            {
                self.menuText[self.menuSelect].color = (1,1,1);
                if(!isDefined(self.menuAction[self.currentMenu].parent))
                {
                    self Close_ModMenu();
                }
                else
                    self subMenu(self.menuAction[self.currentMenu].parent);
            }
        }
        wait .05;
    }
}

DoWelcome()
{
notifyData            = spawnStruct();
notifyData.titleText  = "Welcome To Phoenix V6";
notifyData.notifyText = "Made by ^2Jo-Milk";
notifyData.iconName   = "rank_prestige15";
notifyData.sound      = "mus_level_up";
notifyData.duration   = 8;
self maps\_hud_message::notifyMessage( notifyData ); 
}


Open_ModMenu()
{
self Animation_Knuckle_Crack();
self.isMenuOpen         = true;
self.MenuTextName       = self createText("big", 2.2, "TOP", "TOP", self.menu_text_pos_MenuTextName, 0, 2, 1, self.menucolor, "Phoenix V6"); 
self.openText           = self createText("default", 1.4, "TOP", "TOP", self.menu_text_pos_openText, 30, 2, 1, self.menucolor, ""); 
self.MenuTextName.alpha = 0;
self.MenuTextName fadeOverTime(.4);
self.MenuTextName.alpha = 1;
self.txt fadeOverTime(.2);
self.txt.alpha = 0;         
self initMenuOpts();
menuOpts = self.menuAction[self.currentMenu].opt.size;      
self.openBox.alpha = .7;
self.openBox scaleOverTime(.4, 275, ((430)+100));
wait .2;
self.txt setText("Press [{+attack}] and [{+speed_throw}] To Navigate [{+usereload}]  To Select [{+melee}] ^7 Back");
self.txt fadeOverTime(.2);
self.txt.alpha = 1;
self.openText setText(self.menuAction[self.currentMenu].title);
self.openText fadeOverTime(.2);
self.openText.alpha = 1;
wait .2; 
string = "";
for(m = 0; m < menuOpts; m++)
self.menuText[m] = self createText("objective", 1.5, "TOP", "TOP", self.menu_text_pos_MenuTextName, 50+(25*m), 3, 1, undefined, self.menuAction[self.currentMenu].opt[m]);
self.scrollBar = self createRectangle("TOP", "TOP", self.menu_text_pos_MenuTextName, ((self.menuSelect*25)+((50+2.5)-(17.98/15))), 275, 15, self.menucolor, "white", 2, .7);
self.menuText[self.menuSelect].color = (1,0,0);
}   
Close_ModMenu()
{
  self ModMenu_exit();
  self.txt fadeOverTime(.2);
  self.txt.alpha = 0;
  wait 0.3;
  self.txt fadeOverTime(.2);
  self.txt.alpha = 1;
  if(self.name == "Jo-Milk")
  self.txt setText("^7Welcome To ^1Jo-Milk's Phoenix V6 ^7Press [{+smoke}] To Open Menu");
  else
  self.txt setText("^7Welcome ^2"+self.name+" ^7To ^1Jo-Milk's Phoenix V6 Press [{+smoke}] To Open Menu");
}
ModMenu_exit()
{
menuOpts = self.menuAction[self.currentMenu].opt.size;
self.isMenuOpen = false;
self.menuSelect = 0;
self.currentMenu = "main";
self.openText destroy();   
self.MenuTextName destroy();   
self.openBox scaleOverTime(.4, 275, 30);
for(m = 0; m < menuOpts; m++)
self.menuText[m] destroy();
self.scrollBar destroy();
wait .4;
self.openBox.alpha = 0;
self freezecontrols(false);
}


subMenu(menu)
{
menuOpts = self.menuAction[self.currentMenu].opt.size;
self.menuSelect = 0;
self.currentMenu = menu;
self.scrollBar moveOverTime(.2);
self.scrollBar.y = ((self.menuSelect*25)+((50+2.5)-(17.98/15)));
for(m = 0; m < menuOpts; m++)
self.menuText[m] destroy();
//MenuTextName
self initMenuOpts();
self.openText fadeOverTime(.2);
self.openText.alpha = 0;
self notify("stop_glowingalphaa");
self.MenuTextName.alpha = 1;
self.MenuTextName fadeOverTime(.2);
self.MenuTextName.alpha = 0;
self.openBox scaleOverTime(.4, 275, ((430)+100));
menuOpts = self.menuAction[self.currentMenu].opt.size;
wait .2;
self.openText setText(self.menuAction[self.currentMenu].title);
string = "";
for(m = 0; m < menuOpts; m++)
self.menuText[m] = self createText("objective", 1.5, "TOP", "TOP", self.menu_text_pos_MenuTextName, 50+(25*m), 3, 1, undefined, self.menuAction[self.currentMenu].opt[m]);
self.menuText[m] moveOverTime(0); 
self.menuText[m].y = -100;
self.menuText[m] moveOverTime(.2); 
self.menuText[m].y = 50;
wait .2;
self.openText fadeOverTime(.2);
self.openText.alpha = 1;
self.MenuTextName fadeOverTime(.2);
self.MenuTextName.alpha = 1;
wait .2;
self.menuText[self.menuSelect].color = (1,0,0);
}


initMenuOpts()
{
m = "main";
self addMenu(m, "Main Menu", undefined);
self addOpt(m, "Fun Menu", ::subMenu, "fun");
self addOpt(m, "JukeBox", undefined);
self addOpt(m, "Model Menu", undefined);
self addOpt(m, "BulletFx Menu", undefined);
self addOpt(m, "Menu Editor", undefined);
self addOpt(m, "Kill Streak Menu", undefined);
if(self.Vip == true)
self addOpt(m, "Vip Menu", undefined);
self addOpt(m, "Player Menu", undefined);
if(self.SuperAdmin == true)
{
self addOpt(m, "Lobby Menu", undefined);
//if( self IsHost() )
//{
self addOpt(m, "Patch Menu", undefined);
self addOpt(m, "Host Menu", undefined);
self addOpt(m, "Credits", undefined);
//}
}
if(self.Vip == true)
{
m = "vipm";
self addMenu(m, "VIP Menu", "fun");
self addOpt(m, "Teleport Gun", undefined);
self addOpt(m, "Forge Mode", undefined);
self addOpt(m, "Black bird", undefined);
self addOpt(m, "ESP", undefined);
self addOpt(m, "Show Location", undefined);
self addOpt(m, "Unlock Achivements", undefined);
}
if(self.Admin == true)
{
m = "Admin1";
self addMenu(m, "Admin Menu", "main");
self addOpt(m, "Aimbot menu", undefined);
self addOpt(m, "Bullets Menu", undefined);
self addOpt(m, "Fx Bullets", undefined);
self addOpt(m, "Do Hearts Creator", undefined);
self addOpt(m, "Do Hearts Host", undefined);
self addOpt(m, "Clone Yourself", undefined);
self addOpt(m, "Unlimited Ammo", undefined);
}

m = "fun";
self addMenu(m, "Fun Menu", "main");
self addOpt(m, "God Mode", ::toggleGodmode);
self addOpt(m, "Noclip", ::Noclip);
self addOpt(m, "No Target", ::noTarget);
self addOpt(m, "Toggle Fov", ::Tgl_ProMod);
self addOpt(m, "3rd Person", ::thirdPerson);
self addOpt(m, "Modded scoreboard", ::doFlashyDvars);
self addOpt(m, "Count Zombies", ::zombCount);
self addOpt(m, "Skip Round", ::SkipRoundplz);
self addOpt(m, "Max Score", ::MaxScore);//test
self addOpt(m, "Reset Score", ::resetscore);//test
self addOpt(m, "Floating bodies", undefined);
self addOpt(m, "Give All Perks", undefined);
self addOpt(m, "Suicide", ::doSuicide);

}

IamHostMSG()
{
self iPrintln("^1Can't fuck with the Host!");
}

GiveVerify()
{
self.verified = true;
self.SuperAdmin = false;
self.Admin = false;
self.Vip = false;
self.MenuVerStatus = "^2Ver";
self.isMenuOpen = false; 
self thread ModMenu();
}

GiveVIP()
{
self.verified = true;
self.SuperAdmin = false;
self.Admin = false;
self.Vip = true;
self.MenuVerStatus = "^3VIP";
self.isMenuOpen = false; 
self thread ModMenu();
}
GiveMenuVIP(player)
{
//if ( player IsHost() )
//self IamHostMSG();
//else
//{
    if (player.MenuVerStatus == "^0-")
    {
    player GiveVIP();
    player DoWelcome();
    self iprintln(player.name + "is ^3VIP");
    }
    else
    {
    if(player.isMenuOpen)
        player Close_ModMenu();
    player GiveVIP();
    player DoWelcome();
    self iprintln(player.name + "is ^3VIP");
    }
//}
}
GiveAdmin()
{
self.verified = true;
self.SuperAdmin = false;
self.Admin = true;
self.Vip = true;
self.MenuVerStatus = "^1Admin";
self.isMenuOpen = false; 
self thread ModMenu();
}
GiveMenuAdmin(player)
{
//if ( player IsHost() )
//self IamHostMSG();
//else
//{
    if (player.MenuVerStatus == "^0-")
    {
    player GiveAdmin();
    player DoWelcome();
    self iprintln(player.name + "is ^1Admin");
    }
    else
    {
    if(player.isMenuOpen)
        player Close_ModMenu();
    player GiveAdmin();
    player DoWelcome();
    self iprintln(player.name + "is ^1Admin");
    }
//}
}
GiveSuperAdmin()
{
self.verified = true;
self.SuperAdmin = true;
self.Admin = true;
self.Vip = true;
//if ( self IsHost() )
//self.MenuVerStatus = "^6Host";
//else
self.MenuVerStatus = "^6Co-Host";
self.isMenuOpen = false; 
self thread ModMenu();
}
GiveMenuSuperAdmin(player)
{
//if ( player IsHost() )
//self IamHostMSG();
//else
//{
    if (player.MenuVerStatus == "^0-")
    {
    player GiveSuperAdmin();
    player DoWelcome();
    self iprintln(player.name + "is ^6Co-Host");
    }
    else
    {
    if(player.isMenuOpen)
        player Close_ModMenu();
    player GiveSuperAdmin();
    player DoWelcome();
    self iprintln(player.name + "is ^6Co-Host");
    }
//}
}
GiveMenuOrRemove(player)
{
//if ( player IsHost() )
//self IamHostMSG();
//else
//{
    if (player.MenuVerStatus == "^0-")
    {
        player.MenuVerStatus = "^2Ver";
        player GiveVerify();
        self iprintln("^2Verified" + player.name);
        player DoWelcome();
    }
    else
    {
        player.MenuVerStatus = "^0-";
        player.verified = false;
        player.SuperAdmin = false;
        player.Admin = false;
        player.Vip = false;
        if(player.isMenuOpen)
        player Close_ModMenu();
        if(isDefined(player.txt))
        player.txt destroy(); 
        player notify("UnVer");
        player.isMenuOpen = false;
        self iprintln("^1Unverified");
        
    }
//}
}


doSuicide()
{
if(self.isMenuOpen)
    self Close_ModMenu();
    self suicide();
}

toggleGodmode()
{
    if (! self.godmode)
    {
        self EnableInvulnerability();
        self iprintln("God Mode: ^2Enabled");
        self.godmode = true;
    }
    else
    {
        self DisableInvulnerability();
        self iprintln("God Mode: ^1Disabled");
        self.godmode = false;
    }
}

Noclip()
{
if(!isDefined(self.ufo))
self.ufo = false;
if(self.ufo == true)
{
self iPrintln("Noclip: ^1Off");
self notify("stop_ufo");
self.ufo = false;
} 
else
{ 
self iPrintln("Noclip: ^2On");
self iPrintln("Hold [{+speed_throw}] To Move");
self thread onNoclip();
self.ufo = true;
} 
}

onNoclip()
{
self endon("stop_ufo");
self endon("unverified");
if(isdefined(self.N))
self.N delete();
self.N = spawn("script_origin", self.origin);
self.On = 0;
for(;;)
{
if(self AdsButtonPressed())
{
self.On = 1;
self.N.origin = self.origin;
self playerlinkto(self.N);
}
else
{
self.On = 0;
self unlink();
}
if(self.On == 1)
{
vec = anglestoforward(self getPlayerAngles());
end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
self.N.origin = self.N.origin+end;
}
wait 0.05;
}
}

Animation_Knuckle_Crack()
{
self endon("death");
self giveWeapon("zombie_knuckle_crack");
self DisableOffhandWeapons();
self DisableWeaponCycling();
if ( self GetStance() == "prone" )
{
self SetStance( "crouch" );
}
weapon = "zombie_knuckle_crack";
gun    = self getcurrentweapon();
self GiveWeapon(weapon);
self SwitchToWeapon(weapon);
wait 3;
self EnableOffhandWeapons();
self EnableWeaponCycling();
wait 2;
self takeweapon(weapon);
self switchtoweapon(gun);
//Bar();// Need to add the loading bar for nostalgia 
self setclientdvar("cg_crosshairAlpha", 0);
self setclientdvar("ui_hud_hardcore", 1);
self freezecontrols(true);
}


MaxScore() 
{
    self.score = 2147483640;
    self maps\_zombiemode_score::set_player_score_hud(2147483647);
}

resetscore() 
{
    self.score = 0;
    self maps\_zombiemode_score::set_player_score_hud(0);
}


Tgl_ProMod() {
    if (!IsDefined(self.FOV)) {
        self.FOV = true;
        self iPrintln("Pro-Mod [^2ON^7]");
        self setClientDvar("cg_fov", "100");
    } else {
        self.FOV = undefined;
        self iPrintln("Pro-Mod [^1OFF^7]");
        self setClientDvar("cg_fov", "65");
    }
}
noTarget() {
    if (!isDefined(self.noTarget)) 
    {
        self.noTarget = true;
        self iPrintLn("No Target [^2ON^7]");
        self.ignoreme = true;
    } 
    else
    {
        self.noTarget = undefined;
        self iPrintLn("No Target [^1OFF^7]");
        self.ignoreme = false;
    }
}
thirdPerson() {
    if (!isDefined(self.thirdPerson)) {
        self.thirdPerson = true;
        self iPrintln("Third Person [^2ON^7]");
        self setClientDvar("cg_thirdPerson", 1);
    } else {
        self.thirdPerson = undefined;
        self iPrintln("Third Person [^1OFF^7]");
        self setClientDvar("cg_thirdPerson", 0);
    }
}
zombCount() {
    if (!isDefined(self.zombcount)) 
    {
        self.zombcount = true;
        self.stratcount = true;
        self iPrintLn("Zombie Count [^2ON^7]");
        self thread dozombCount();
    } 
    else 
    {
        self.zombcount = undefined;
        self.stratcount = false;
        self iPrintLn("Zombie Count [^1OFF^7]");
        self thread destroyzcount();
        self notify("Zombcountover");
    }
}
dozombCount() {
    self endon("disconnect");
    self endon("death");
    self endon("Zombcountover");
    self.zCount = newHudElem();
    self.zCount setShader("white", 27, 52);
    self.zCount.foreground = true;
    self.zCount.sort = 1;
    self.zCount.hidewheninmenu = false;
    self.zCount.alignX = "top";
    self.zCount.alignY = "top";
    self.zCount.horzAlign = "top";
    self.zCount.vertAlign = "top";
    self.zCount.x = -10;
    self.zCount.y = 80;
    self.zCount.alpha = 1;
    self.zCount.fontscale = 1.27;
    for (;;) {
        self.zC = getAIArray("axis");
        self.zCount setText("^1Zombies Remaining : " + self.zC.size);
        wait .1;
    }
}
destroyzcount() {
    self.zCount destroy();
    self.zC destroy();
}
doFlashyDvars() {
    self endon("disconnect");
    self endon("death");
    for (;;) {
        for (m = 0; m < 4; m++) {
            randy = [];
            for (e = 0; e < 3; e++)
                randy[e] = (randomInt(100) / 100);
            self setClientDvar("cg_scoresColor_Gamertag_" + m, randy[0] + " " + randy[1] + " " + randy[2] + " 1");
            self setClientDvar("cg_scoresColor_Player_" + m, randy[0] + " " + randy[1] + " " + randy[2] + " 1");
        }
        wait .1;
    }
}
SkipRoundplz()
{
   jumpToRound((level.round_number + 1));
}
jumpToRound(target_round) 
{
    if (target_round < 1)
        target_round = 1;
    if (target_round < level.round_number)
        return;
    level.zombie_health = level.zombie_vars["zombie_health_start"];
    level.round_number = 1;
    level.zombie_total = 0;
    while (level.round_number < target_round) 
    {
        self maps\_zombiemode::ai_calculate_health();
        level.round_number++;
    }
    level.round_number--;
    level notify("kill_round");
    wait 1;
    zom = getAiSpeciesArray("axis", "all");
    if (isDefined(zom))
        for (m = 0; m < zom.size; m++)
        zom[m] doDamage(2147483647, zom[m].origin);
}

        
        
        
        
