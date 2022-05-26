// Cryptopals crypto challenge - set 1 challenge 1
// https://cryptopals.com/sets/1/challenges/1

fn main() {
    let hex_sample = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d";
    let base64_sample = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t";

    let bin = hex_str_to_bin(hex_sample);

    if base64_sample == bin_to_base64_str(&bin) {
        println!("Pass")
    } else {
        println!("FAIL!")
    }
}

fn hex_str_to_bin(_hex: &str) -> Vec<u8> {
    vec![]
}

fn bin_to_base64_str(_bin: &Vec<u8>) -> String {
    "".to_string()
}
