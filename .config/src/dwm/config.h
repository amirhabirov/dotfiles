/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* Helper macros for spawning commands */
#define SHCMD(cmd)          { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define CMD(...)            { .v = (const char*[]){ __VA_ARGS__, NULL } }
#define VOLCMD(cmd, action) { "/usr/bin/wpctl", cmd, "@DEFAULT_AUDIO_SINK@", action }

/* appearance */
static const unsigned int borderpx       = 1;   /* border pixel of windows */
static const unsigned int snap           = 0;   /* snap pixel */
static const int showbar                 = 1;   /* 0 means no bar */
static const int topbar                  = 1;   /* 0 means bottom bar */
static const unsigned int systrayspacing = 0;   /* systray spacing */
static const int showsystray             = 1;   /* 0 means no systray */

static const char *fonts[] = { "Lexend:pixelsize=22" };

/* Status is to be shown on: -1 (all monitors), 0 (a specific monitor by index), 'A' (active monitor) */
static const int statusmon = 'A';

/* Indicators: see patch/bar_indicators.h for options */
static int tagindicatortype   = INDICATOR_TOP_LEFT_LARGER_SQUARE;
static int tiledindicatortype = INDICATOR_TOP_LEFT_LARGER_SQUARE;
static int floatindicatortype = INDICATOR_TOP_LEFT_LARGER_SQUARE;

#define black  "#333333"
#define white  "#ffffea"
#define gray   "#d3d3d3"

static char c000000[]             = black;

static char normfgcolor[]         = black;
static char normbgcolor[]         = white;
static char normbordercolor[]     = gray;
static char normfloatcolor[]      = gray;

static char selfgcolor[]          = white;
static char selbgcolor[]          = black;
static char selbordercolor[]      = black;
static char selfloatcolor[]       = black;

static char tagsnormfgcolor[]     = black;
static char tagsnormbgcolor[]     = white;
static char tagsnormbordercolor[] = black;
static char tagsnormfloatcolor[]  = black;

static char tagsselfgcolor[]      = black;
static char tagsselbgcolor[]      = gray;
static char tagsselbordercolor[]  = black;
static char tagsselfloatcolor[]   = black;

static char urgfgcolor[]          = white;
static char urgbgcolor[]          = black;
static char urgbordercolor[]      = black;
static char urgfloatcolor[]       = black;

/* Useless */ 
static char titlenormfgcolor[]     = black;
static char titlenormbgcolor[]     = black;
static char titlenormbordercolor[] = black;
static char titlenormfloatcolor[]  = black;
static char titleselfgcolor[]      = black;
static char titleselbgcolor[]      = black;
static char titleselbordercolor[]  = black;
static char titleselfloatcolor[]   = black;
static char hidnormfgcolor[]       = black;
static char hidselfgcolor[]        = black;
static char hidnormbgcolor[]       = black;
static char hidselbgcolor[]        = black;

static char *colors[][ColCount] = {
	/*                       fg                bg                border                float */
	[SchemeNorm]         = { normfgcolor,      normbgcolor,      normbordercolor,      normfloatcolor },
	[SchemeSel]          = { selfgcolor,       selbgcolor,       selbordercolor,       selfloatcolor },
	[SchemeTitleNorm]    = { titlenormfgcolor, titlenormbgcolor, titlenormbordercolor, titlenormfloatcolor },
	[SchemeTitleSel]     = { titleselfgcolor,  titleselbgcolor,  titleselbordercolor,  titleselfloatcolor },
	[SchemeTagsNorm]     = { tagsnormfgcolor,  tagsnormbgcolor,  tagsnormbordercolor,  tagsnormfloatcolor },
	[SchemeTagsSel]      = { tagsselfgcolor,   tagsselbgcolor,   tagsselbordercolor,   tagsselfloatcolor },
	[SchemeHidNorm]      = { hidnormfgcolor,   hidnormbgcolor,   c000000,              c000000 },
	[SchemeHidSel]       = { hidselfgcolor,    hidselbgcolor,    c000000,              c000000 },
	[SchemeUrg]          = { urgfgcolor,       urgbgcolor,       urgbordercolor,       urgfloatcolor },
};

/* Tags
 * In a traditional dwm the number of tags in use can be changed simply by changing the number
 * of strings in the tags array. This build does things a bit different which has some added
 * benefits. If you need to change the number of tags here then change the NUMTAGS macro in dwm.c.
 *
 * Examples:
 *
 *  1) static char *tagicons[][NUMTAGS*2] = {
 *         [DEFAULT_TAGS] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I" },
 *     }
 *
 *  2) static char *tagicons[][1] = {
 *         [DEFAULT_TAGS] = { "•" },
 *     }
 *
 * The first example would result in the tags on the first monitor to be 1 through 9, while the
 * tags for the second monitor would be named A through I. A third monitor would start again at
 * 1 through 9 while the tags on a fourth monitor would also be named A through I. Note the tags
 * count of NUMTAGS*2 in the array initialiser which defines how many tag text / icon exists in
 * the array. This can be changed to *3 to add separate icons for a third monitor.
 *
 * For the second example each tag would be represented as a bullet point. Both cases work the
 * same from a technical standpoint - the icon index is derived from the tag index and the monitor
 * index. If the icon index is is greater than the number of tag icons then it will wrap around
 * until it an icon matches. Similarly if there are two tag icons then it would alternate between
 * them. This works seamlessly with alternative tags and alttagsdecoration patches.
 */
static char *tagicons[][NUMTAGS] = {
	[DEFAULT_TAGS]        = { "!", "@", "#"},
	[ALTERNATIVE_TAGS]    = { "!", "@", "#"},
	[ALT_TAGS_DECORATION] = { "!", "@", "#"},
};

/* There are two options when it comes to per-client rules:
 *  - a typical struct table or
 *  - using the RULE macro
 *
 * A traditional struct table looks like this:
 *    // class      instance  title  wintype  tags mask  isfloating  monitor
 *    { "Gimp",     NULL,     NULL,  NULL,    1 << 4,    0,          -1 },
 *    { "Firefox",  NULL,     NULL,  NULL,    1 << 7,    0,          -1 },
 *
 * The RULE macro has the default values set for each field allowing you to only
 * specify the values that are relevant for your rule, e.g.
 *
 *    RULE(.class = "Gimp", .tags = 1 << 4)
 *    RULE(.class = "Firefox", .tags = 1 << 7)
 *
 * Refer to the Rule struct definition for the list of available fields depending on
 * the patches you enable.
 */
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 *	WM_WINDOW_ROLE(STRING) = role
	 *	_NET_WM_WINDOW_TYPE(ATOM) = wintype
	 */
	RULE(.wintype = WTYPE "DIALOG",  .isfloating = 1)
	RULE(.wintype = WTYPE "UTILITY", .isfloating = 1)
	RULE(.wintype = WTYPE "TOOLBAR", .isfloating = 1)
	RULE(.wintype = WTYPE "SPLASH",  .isfloating = 1)
	RULE(.class   = "GoldenDict-ng", .isfloating = 1)
	RULE(.class    = "mpv",          .isfloating = 1)
};

/* Bar rules allow you to configure what is shown where on the bar, as well as
 * introducing your own bar modules.
 *
 *    monitor:
 *      -1  show on all monitors
 *       0  show on monitor 0
 *      'A' show on active monitor (i.e. focused / selected) (or just -1 for active?)
 *    bar - bar index, 0 is default, 1 is extrabar
 *    alignment - how the module is aligned compared to other modules
 *    widthfunc, drawfunc, clickfunc - providing bar module width, draw and click functions
 *    name - does nothing, intended for visual clue and for logging / debugging
 */
static const BarRule barrules[] = {
	/* monitor   bar alignment        widthfunc       drawfunc       clickfunc       hoverfunc   name */
	{ -1,        0,  BAR_ALIGN_LEFT,  width_tags,     draw_tags,     click_tags,     hover_tags, "tags"    },
	{  0,        0,  BAR_ALIGN_RIGHT, width_systray,  draw_systray,  click_systray,  NULL,       "systray" },
	{ -1,        0,  BAR_ALIGN_LEFT,  width_ltsymbol, draw_ltsymbol, click_ltsymbol, NULL,       "layout"  },
	{ statusmon, 0,  BAR_ALIGN_RIGHT, width_status,   draw_status,   click_status,   NULL,       "status"  },
};

/* layout(s) */
static const float mfact        = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;   /* number of clients in master area */
static const int resizehints    = 0;   /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1;   /* 1 will force focus on the fullscreen window */
static const int refreshrate    = 144; /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
	/* symbol arrange function */
	{ "[]=",  tile }, /* first entry is default */
	{ "><>",  NULL }, /* no layout function means floating behavior */
	{ "[M]",  monocle },
};

/* key definitions */
#define NOMODKEY 0
#define MODKEY   Mod4Mask
#define ALT      Mod1Mask
#define CTRL     ControlMask
#define SHIFT    ShiftMask

#define RAISEVOL XF86XK_AudioRaiseVolume
#define LOWERVOL XF86XK_AudioLowerVolume
#define MUTEVOL  XF86XK_AudioMute

#define TAGKEYS(KEY,TAG) \
	{ MODKEY,            KEY, comboview,  {.ui = 1 << TAG} }, \
	{ MODKEY|CTRL,       KEY, toggleview, {.ui = 1 << TAG} }, \
	{ MODKEY|SHIFT,      KEY, combotag,   {.ui = 1 << TAG} }, \
	{ MODKEY|CTRL|SHIFT, KEY, toggletag,  {.ui = 1 << TAG} },

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */

static const char *dmenucmd[]     = { "dmenu_run", "-m", dmenumon, NULL };
static const char *termcmd[]      = { "st", NULL };
static const char *clipmenucmd[]  = { "clipmenu", "-p", "", "-l", "10",  NULL };
static const char *firefoxcmd[]   = { "firefox", NULL };
static const char *sioyekcmd[]    = { "sioyek", NULL };
static const char *flameshotcmd[] = { "flameshot", "gui", NULL };
static const char *slockcmd[]     = { "slock", NULL };
static const char goldendictcmd[] = "~/.config/src/dwm/scripts/goldendict.sh";
static const char switchcmd[]     = "~/.config/src/dwm/scripts/switch.sh";
static const char *raisevol[]     = VOLCMD("set-volume", "5%+");
static const char *lowervol[]     = VOLCMD("set-volume", "5%-");
static const char *mutevol[]      = VOLCMD("set-mute", "toggle");

static const Key keys[] = {
	/* modifier     key        function        argument */
	{ MODKEY,       XK_d,      spawn,          {.v = dmenucmd } },
	{ MODKEY|SHIFT, XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY|ALT,   XK_v,      spawn,          {.v = clipmenucmd } },
	{ MODKEY|SHIFT, XK_b,      spawn,          {.v = firefoxcmd } },
	{ MODKEY|SHIFT, XK_s,      spawn,          {.v = sioyekcmd } },
	{ MODKEY,       XK_p,      spawn,          {.v = flameshotcmd } },
	{ MODKEY|SHIFT, XK_p,      spawn,          {.v = slockcmd } },
	{ MODKEY,       XK_q,      spawn,          SHCMD(goldendictcmd) },
	{ MODKEY,       XK_w,      spawn,          SHCMD(switchcmd) },
	{ NOMODKEY,     RAISEVOL,  spawn,          {.v = raisevol } },
	{ NOMODKEY,     LOWERVOL,  spawn,          {.v = lowervol } },
	{ NOMODKEY,     MUTEVOL,   spawn,          {.v = mutevol } },
	{ MODKEY,       XK_b,      togglebar,      {0} },
	{ MODKEY,       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,       XK_h,      setmfact,       {.f = -0.15} },
	{ MODKEY,       XK_l,      setmfact,       {.f = +0.15} },
	{ MODKEY,       XK_Return, zoom,           {0} },
	{ MODKEY,       XK_Tab,    view,           {0} },
	{ MODKEY|SHIFT, XK_q,      killclient,     {0} },
	{ MODKEY|SHIFT, XK_e,      quit,           {0} },
	{ MODKEY,       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,       XK_space,  setlayout,      {0} },
	{ MODKEY|SHIFT, XK_space,  togglefloating, {0} },
	{ MODKEY,       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|SHIFT, XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|SHIFT, XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|SHIFT, XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(        XK_1,                      0)
	TAGKEYS(        XK_2,                      1)
	TAGKEYS(        XK_3,                      2)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click        event mask button   function     argument */
	{ ClkClientWin, MODKEY,    Button1, movemouse,   {0} },
	{ ClkClientWin, MODKEY,    Button3, resizemouse, {0} },
};
