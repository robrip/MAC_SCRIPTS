#!/usr/bin/env bash
# ROBRip CIDR Analyzer v3 — Direct Display Edition (with Private Range Critical Flagging)

FILE="$1"
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
    echo "Error: Provide a valid file of IPs + CIDRs"
    exit 1
fi

TMP=$(mktemp)
SUMMARY_ALL=""
TOTAL_CIDRS=0
TOTAL_USABLE_SUM=0
DANGEROUS_COUNT=0
HIGHEST_RISK_CIDR=""
HIGHEST_RISK_USABLE=0

# Colors
RED="\033[1;31m"
GREEN="\033[0;32m"
WHITE="\033[1;37m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
RESET="\033[0m"
YELLOW="\033[1;33m"

echo -e "${MAGENTA}═══════════════════════════════════════════════"
echo -e "   🧠  ROBRip CIDR Analyzer v3 (Direct Display)  🧠"
echo -e "═══════════════════════════════════════════════${RESET}"
echo

###############################################
# Normalize input
###############################################
while read -r LINE; do
    [ -z "$LINE" ] && continue
    if echo "$LINE" | grep -q "/"; then
        echo "$LINE" >> "$TMP"
    else
        echo "$LINE/32" >> "$TMP"
    fi
done < "$FILE"

sort -t. -k1,1n -k2,2n -k3,3n -k4,4n "$TMP" | while read -r ENTRY; do
    IP="${ENTRY%/*}"
    MASK="${ENTRY#*/}"
    IFS=. read -r o1 o2 o3 o4 <<< "$IP"
    INT=$(( (o1<<24) + (o2<<16) + (o3<<8) + o4 ))
    NETMASK=$(( 0xFFFFFFFF << (32 - MASK) & 0xFFFFFFFF ))
    NETWORK=$(( INT & NETMASK ))
    CIDR="$(printf "%d.%d.%d.%d/%d" $((NETWORK>>24&255)) $((NETWORK>>16&255)) $((NETWORK>>8&255)) $((NETWORK&255)) "$MASK")"
    echo "$CIDR $IP"
done | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n -k5,5n > "${TMP}.sorted"

###############################################
# Build block summaries
###############################################
CURRENT=""
COUNT=0

while read -r CIDR IP; do
    if [ "$CIDR" != "$CURRENT" ]; then
        if [ -n "$CURRENT" ]; then
            MASK="${CURRENT#*/}"
            TOTAL=$(( 2 ** (32 - MASK) ))
            USABLE=$(( MASK <= 30 ? TOTAL - 2 : TOTAL ))

            USABLE_COLOR=$([ "$USABLE" -gt 1 ] && echo "$RED" || echo "$GREEN")
            TOTAL_COLOR=$([ "$TOTAL" -gt 1 ] && echo "$RED" || echo "$GREEN")
            WARN_ICON=$([ "$TOTAL" -gt 1 ] && echo -e "\033[5m⚠️\033[25m" || echo "")

            ###############################################
            # PRIVATE RANGE DETECTION — FORCE CRITICAL
            ###############################################
            PRIVATE_BANNER=""
            if [[ "$CURRENT" =~ ^192\.168\. ]] || \
               [[ "$CURRENT" =~ ^10\. ]] || \
               [[ "$CURRENT" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]; then

                PRIVATE_BANNER="${MAGENTA}🚨 PRIVATE RANGE DETECTED — SHOULD NOT APPEAR HERE 🚨${RESET}\n"

                SEVERITY="${RED}Risk: █████ (Critical – Private Range)${RESET}"
                USABLE_COLOR="${RED}"
                TOTAL_COLOR="${RED}"
                WARN_ICON="\033[5m⚠️\033[25m"
            else
                # Normal severity logic
                if [ "$USABLE" -le 1 ]; then
                    SEVERITY="${GREEN}Risk: █░░░░ (Low)${RESET}"
                elif [ "$USABLE" -le 30 ]; then
                    SEVERITY="${YELLOW}Risk: ██░░░ (Medium)${RESET}"
                elif [ "$USABLE" -le 254 ]; then
                    SEVERITY="${RED}Risk: ████░ (High)${RESET}"
                else
                    SEVERITY="${RED}Risk: █████ (Critical)${RESET}"
                fi
            fi

            TOTAL_CIDRS=$((TOTAL_CIDRS + 1))
            TOTAL_USABLE_SUM=$((TOTAL_USABLE_SUM + USABLE))
            [ "$USABLE" -gt 1 ] && DANGEROUS_COUNT=$((DANGEROUS_COUNT + 1))
            if [ "$USABLE" -gt "$HIGHEST_RISK_USABLE" ]; then
                HIGHEST_RISK_USABLE="$USABLE"
                HIGHEST_RISK_CIDR="$CURRENT"
            fi

            BLOCK_SUMMARY="${PRIVATE_BANNER}${CYAN}🧩 $CURRENT${RESET}
   • ${WHITE}IPs in this block:${RESET} ${GREEN}$(printf "%10d" "$COUNT")${RESET}
   • ${WHITE}Usable IPs:${RESET}        ${USABLE_COLOR}$(printf "%10d" "$USABLE")${RESET}
   • ${WHITE}${SEVERITY}${RESET}
   ${WHITE}This CIDR contains${RESET} ${TOTAL_COLOR}${TOTAL}${RESET}${WARN_ICON} ${WHITE}total IPs.${RESET}
"

            echo -e "$BLOCK_SUMMARY"
            SUMMARY_ALL="${SUMMARY_ALL}${BLOCK_SUMMARY}"
        fi
        CURRENT="$CIDR"
        COUNT=0
    fi
    COUNT=$(( COUNT + 1 ))
done < "${TMP}.sorted"

# Final block (same logic as above)
if [ -n "$CURRENT" ]; then
    MASK="${CURRENT#*/}"
    TOTAL=$(( 2 ** (32 - MASK) ))
    USABLE=$(( MASK <= 30 ? TOTAL - 2 : TOTAL ))

    USABLE_COLOR=$([ "$USABLE" -gt 1 ] && echo "$RED" || echo "$GREEN")
    TOTAL_COLOR=$([ "$TOTAL" -gt 1 ] && echo "$RED" || echo "$GREEN")
    WARN_ICON=$([ "$TOTAL" -gt 1 ] && echo -e "\033[5m⚠️\033[25m" || echo "")

    PRIVATE_BANNER=""
    if [[ "$CURRENT" =~ ^192\.168\. ]] || \
       [[ "$CURRENT" =~ ^10\. ]] || \
       [[ "$CURRENT" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]; then

        PRIVATE_BANNER="${MAGENTA}🚨 PRIVATE RANGE DETECTED — SHOULD NOT APPEAR HERE 🚨${RESET}\n"

        SEVERITY="${RED}Risk: █████ (Critical – Private Range)${RESET}"
        USABLE_COLOR="${RED}"
        TOTAL_COLOR="${RED}"
        WARN_ICON="\033[5m⚠️\033[25m"
    else
        if [ "$USABLE" -le 1 ]; then
            SEVERITY="${GREEN}Risk: █░░░░ (Low)${RESET}"
        elif [ "$USABLE" -le 30 ]; then
            SEVERITY="${YELLOW}Risk: ██░░░ (Medium)${RESET}"
        elif [ "$USABLE" -le 254 ]; then
            SEVERITY="${RED}Risk: ████░ (High)${RESET}"
        else
            SEVERITY="${RED}Risk: █████ (Critical)${RESET}"
        fi
    fi

    BLOCK_SUMMARY="${PRIVATE_BANNER}${CYAN}🧩 $CURRENT${RESET}
   • ${WHITE}IPs in this block:${RESET} ${GREEN}$(printf "%10d" "$COUNT")${RESET}
   • ${WHITE}Usable IPs:${RESET}        ${USABLE_COLOR}$(printf "%10d" "$USABLE")${RESET}
   • ${WHITE}${SEVERITY}${RESET}
   ${WHITE}This CIDR contains${RESET} ${TOTAL_COLOR}${TOTAL}${RESET}${WARN_ICON} ${WHITE}total IPs.${RESET}
"

    echo -e "$BLOCK_SUMMARY"
    SUMMARY_ALL="${SUMMARY_ALL}${BLOCK_SUMMARY}"
fi

rm -f "$TMP" "${TMP}.sorted"

###############################################
# Summary footer
###############################################
echo -e "${MAGENTA}==============================================${RESET}"
echo -e "${WHITE}CIDR Analysis Summary${RESET}"
echo -e "${MAGENTA}==============================================${RESET}"
echo -e "   • ${WHITE}Total CIDRs:${RESET}            ${GREEN}$TOTAL_CIDRS${RESET}"
echo -e "   • ${WHITE}Total Usable IPs:${RESET}       ${GREEN}$TOTAL_USABLE_SUM${RESET}"
echo -e "   • ${WHITE}Dangerous Blocks:${RESET}       ${RED}$DANGEROUS_COUNT${RESET}"
echo -e "   • ${WHITE}Highest-Risk Block:${RESET}     ${RED}$HIGHEST_RISK_CIDR${RESET}"
echo -e "   • ${WHITE}Highest-Risk Usable IPs:${RESET} ${RED}$HIGHEST_RISK_USABLE${RESET}"
echo -e "${MAGENTA}==============================================${RESET}"
echo