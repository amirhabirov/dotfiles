/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

#define black  "#333333"
#define white  "#ffffea"
#define gray   "#d3d3d3"

static int topbar     = 1; /* -b  option; if 0, dmenu appears at bottom  */
static int centered   = 1; /* -c option; centers dmenu on screen */
static int min_width  = 100; /* minimum width when centered */

/* This is the ratio used in the original calculation */
static const float menu_height_ratio = 2.0f;  

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = { "Lexend:pixelsize=28" };

static const char *prompt = NULL; /* -p  option; prompt to the left of input field */

static const char *colors[SchemeLast][2] = {
	/*                 fg     bg */
	[SchemeNorm]   = { black, white },
	[SchemeSel]    = { black, gray  },
	[SchemeOut]    = { NULL,  NULL  },
	[SchemeBorder] = { black, NULL  },
};

/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines = 10;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static unsigned int border_width = 1;

