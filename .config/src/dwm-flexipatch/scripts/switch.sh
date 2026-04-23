windows=$(wmctrl -xl | tr -s '[:blank:]' | cut -d ' ' -f 3-3,5- | sed 's/^[a-zA-Z0-9-]*\.//' | sort | uniq)

test -n "$windows" || exit 0

# Add spaces to align the WM_NAMEs of the windows
max=$(echo "$windows" | awk '{cur=length($1); max=(cur>max?cur:max)} END{print max}')

windows=$(echo "$windows" | \
              awk -v max="$max" \
                  'BEGIN {num=1} 
                   {printf "%d | ", num++; cur=length($1); printf $1; \
                    for(i=0; i < max - cur; i++) printf " "; \
                    $1 = ""; printf " |%s\n", $0}')
                  
target=$(echo "$windows" | dmenu -l 10 | tr -s '[:blank:]' | cut -d ' ' -f 5-)

test -z "$target" || wmctrl -a "$target"
