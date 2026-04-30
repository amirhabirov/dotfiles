/* user and group to drop privileges to */
static const char *user  = "amirhabirov";
static const char *group = "amirhabirov"; // use "nobody" for arch

#define black "black"
#define white "#ffffea"
#define gray  "#d3d3d3"

static const char *colorname[NUMCOLS] = {
	[INIT]   = black, /* after initialization */
	[INPUT]  = gray,  /* during input */
	[FAILED] = white, /* wrong password */
};

/* default message */
static const char * message = "";

/* text color */
static const char * text_color = black;

/* text size (must be a valid size) */
static const char * font_name = "lucidasanstypewriter-bold-24";

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

static const secretpass scom[] = {
	/* Password   command */
	{ "poweroff", "sudo poweroff"},
	{ "shutdown", "sudo poweroff"},
	{ "reboot",   "sudo reboot"},
};
