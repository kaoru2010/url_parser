%option nounput noinput noyywrap nodefault 8bit
%x hostport path search_key search_value hash

domainlabel [[:alnum:]]|[[:alnum:]][[:alnum:]-]*[[:alnum:]]
toplabel [[:alpha:]]|[[:alpha:]][[:alnum:]-]*[[:alnum:]]
search [^#&=]

%%

"http://" { BEGIN(hostport); printf("[HTTP] %s\n", yytext); }
"https://" { BEGIN(hostport); printf("[HTTPS] %s\n", yytext); }

<hostport>{
    [[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+ { printf("[hostnumber] %s\n", yytext); }
    ({domainlabel}\.)*{toplabel} { printf("[hostname] %s\n", yytext); }
    :[[:digit:]]+ { printf("[port] %s\n", yytext + 1); }
    "/" { BEGIN(path); }
}

<path>{
    [^?#]+ { printf("[path] /%s\n", yytext); }
    "?" BEGIN(search_key);
    "#" BEGIN(hash);
}

<search_key>{
    {search}+ { printf("[search_key] %s\n", yytext); }
    "=" BEGIN(search_value);
    "#" BEGIN(hash);
}

<search_value>{
    {search}+ { printf("[search_value] %s\n", yytext); }
    "&" BEGIN(search_key);
    "#" BEGIN(hash);
}

<hash>{
    .* { printf("[hash] %s\n", yytext); }
}

<*>{
    . return 0;
    \n return 0;
}

%%

int main()
{
    yylex();
    return 0;
}
