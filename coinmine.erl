-module(coinmine).

-import(string, [concat/2]).
-import(timer, [now_diff/2]).
-export([gen_rnd/2, main/0, bitcoin_mining_boss/2, generate_hashcode/1,
         bitcoin_mining_worker/3, concat_zeros/2]).

% func to implement actor model
% Boss func that takes number of zeros as input from main func
% gets the mined bitcoins along with hashcode with leading
% required number of zeros from the actors
bitcoin_mining_boss(_Number_of_Zeros, 0) ->
    io:fwrite("");
bitcoin_mining_boss(Number_of_Zeros, Number_of_coins) ->
    String = gen_rnd(6, "abcdefghijklmnopqrstuvwxyz1234567890"),
    Bitcoin_to_be_hashed = concat("namitanamita;", String),
    Final_hash = generate_hashcode(Bitcoin_to_be_hashed),
    Len1 = 64 - Number_of_Zeros,
    Len2 = string:length(Final_hash),
    if Len1 >= Len2 ->
        Len3 = 64 - Len2,
           Final_hash_with_zeros = concat_zeros(Final_hash, Len3),
           io:fwrite("~s   ~p ~n", [Bitcoin_to_be_hashed, Final_hash_with_zeros]),
           bitcoin_mining_boss(Number_of_Zeros, Number_of_coins - 1);
       true ->
           bitcoin_mining_boss(Number_of_Zeros, Number_of_coins)
    end,
    receive
        %%waits here for result from actors, matches below pattern with the result
        %% outputs the bitcoin and its hashcode.
        {[Mains, H]} ->
            io:fwrite("~s   ~p ~n", [Mains, H])
    end.
% % func to generate random string
% Input :- length and allowed characters using which string will be generated
% Output :- Random generated String of input length.
gen_rnd(Length, AllowedChars) ->
    MaxLength = length(AllowedChars),
    lists:foldl(fun(_, Acc) ->
                   [lists:nth(
                        rand:uniform(MaxLength), AllowedChars)]
                   ++ Acc
                end,
                [],
                lists:seq(1, Length)).

% func to generate hash code
% Input :- String to be hashed
% Output :- Hashed string with base 16.
generate_hashcode(String) ->
    Hash8bit = crypto:hash(sha256, String),
    Hash_int = crypto:bytes_to_integer(Hash8bit),
    _Final_Hash = integer_to_list(Hash_int, 16).
