% display_menu TODO should this go to display.pl? yes we can

:- consult('textbeauty.pl').

display_logo :-
    write('  ____  _____  ______          _  _________ _    _ _____   ____  _    _  _____ _    _\n'),
    write(' |  _ \\|  __ \\|  ____|   /\\   | |/ /__   __| |  | |  __ \\ / __ \\| |  | |/ ____| |  | |\n'),
    write(' | |_) | |__) | |__     /  \\  | \' /   | |  | |__| | |__) | |  | | |  | | |  __| |__| |\n'),
    write(' |  _ <|  _  /|  __|   / /\\ \\ |  <    | |  |  __  |  _  /| |  | | |  | | | |_ |  __  |\n'),
    write(' | |_) | | \\ \\| |____ / ____ \\| . \\   | |  | |  | | | \\ \\| |__| | |__| | |__| | |  | |\n'),
    write(' |____/|_|  \\_\\______/_/    \\_\\_|\\_\\  |_|  |_|  |_|_|   \\_\\____/ \\____/ \\_____|_|  |_|\n').

display_menu :-
    write('\n\n'),
    print_game_banner('MAIN MENU'),
    write('\n\n'),
    write('1 - start game\n'),
    write('2 - rules\n'),
    write('3 - quit game\n'),
    write('\n').

    

    

