BEGIN {
    NAME = ""
    WIDTH = 12
    SEP="\001"
    count = 0
}

function handle(name){
    if (pat == "" || match(pat, name)) {
        printf("%12s\t%s\n", name,  data[name SEP "desc"])
        printf("%12s\t%s\n", "",    "cmd:" data[name SEP "cmd"])
        printf("%12s\t%s\n", "",    "ref:" data[name SEP "reference"])
        count = count + 1
    }
}

$0!~/^#/{
    leading_space = match(/^[\ ]+/, $0)
    leading_space_len = length(leading_space)
    print leading_space_len

    if (leading_space_len == 0) {
        if (NAME != "") {
            handle(NAME)
        }
        NAME = gsub(/[\ ]+$/, "", $0)
    } else if (leading_space_len == 4) {
        kw = $1
        if (kw ~ /:$/) {
            gsub(/:$/, "", kw)
        }

        $1 = ""
        s = gsub(/[\ ]+$/, "", $0)
        s = gsub(/^[\ ]+/, "", s)
        data[NAME SEP kw] = $0
    }
}

end{
    if (NAME != "") {
        handle(NAME)
    }

    if (pat != "") {
        if (count == 0) exit(1)
        if (count == 1) exit(0)
        exit(0) # success
    }
}