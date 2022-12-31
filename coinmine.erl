-module(coinmine).

-import(string, [concat/2]).
-import(timer, [now_diff/2]).
-export([gen_rnd/2, main/0, bitcoin_mining_boss/2, generate_hashcode/1,
         bitcoin_mining_worker/3, concat_zeros/2]).

% bitcoin_mining_worker(_From, _Number_of_zeros, 0) ->
%     io:fwrite("");
% bitcoin_mining_worker(From, Number_of_zeros, Number_of_coins) ->
%     String = gen_rnd(6, "abcdefghijklmnopqrstuvwxyz1234567890"),
%     Bitcoin_to_be_hashed = concat("namitanamita;", String),
%     Final_hash = generate_hashcode(Bitcoin_to_be_hashed),
%     Len1 = 64 - Number_of_zeros,
%     Len2 = string:length(Final_hash),
%     if Len1 >= Len2 ->
%         Len3 = 64 - Len2,
%            Final_hash_with_zeros = concat_zeros(Final_hash, Len3),
%            From ! {[Bitcoin_to_be_hashed, Final_hash_with_zeros]},
%            bitcoin_mining_worker(From, Number_of_zeros, Number_of_coins - 1);
%        true ->
%            bitcoin_mining_worker(From, Number_of_zeros, Number_of_coins)
%     end.
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
% func to concatenate zeros infront of hashcode of the mined bitcoins.
concat_zeros(String, 0) ->
    _Final_hash = concat("", String);
concat_zeros(String, Number_of_zeros) ->
    Final_hash = concat("0", String),
    concat_zeros(Final_hash, Number_of_zeros - 1).