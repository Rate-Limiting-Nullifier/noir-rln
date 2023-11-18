use dep::std::hash::poseidon::bn254::hash_2;

global DEPTH = 16;

pub fn merkle_proof<N>(leaf: Field, pathSelectors: [u1; N], pathElements: [Field; N]) -> Field {
    let mut hash = leaf;

    for i in 0..N {
        let hash_input = if pathSelectors[i] == 1 {
            [pathElements[i], hash]
        } else {
            [hash, pathElements[i]]
        };

        hash = hash_2(hash_input);
    }

    hash
}