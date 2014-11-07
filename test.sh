function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) true ;;
        n|no)  false ;;
        *) ask_yes_or_no ;;
    esac
}

(ask_yes_or_no \
    && echo "Let's Go!!!") \
|| echo "Ok ..."
