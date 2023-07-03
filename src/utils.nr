use dep::std::hash::poseidon::bn254::hash_2;

global DEPTH = 16;
global HASHES_LENGTH = 17;

fn merkle_proof<N>(leaf: Field, pathSelectors: [Field; N], pathElements: [Field; N]) -> Field {
    let mut levelHashes = [0; HASHES_LENGTH];
    levelHashes[0] = leaf;

    for i in 0..N {
        assert(pathSelectors[i] * (pathSelectors[i] - 1) == 0);

        let leaves = mux(
            [levelHashes[i], pathElements[i], pathElements[i], levelHashes[i]],
            pathSelectors[i]
        );

        levelHashes[i + 1] = hash_2([leaves[0], leaves[1]]);
    }

    levelHashes[N]
}

fn mux(c: [Field; 4], s: Field) -> [Field; 2] {
    let mut out: [Field; 2] = [0; 2];

    out[0] = (c[1] - c[0]) * s + c[0];
    out[1] = (c[3] - c[2]) * s + c[2];

    out
}