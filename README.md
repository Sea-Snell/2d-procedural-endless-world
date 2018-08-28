# 2d-procedural-endless-world

2d endless world, complete with rugged tarrain, caves, floating islands, water - an incomplete feature, and varying biomes.

I use 1d perlin noise to determine the terrain height, then 2d perlin noise to create the caves and floating islands.

Biomes blend smoothly into each-other, thanks to a whole bunch of math, and a 1d perlin noise function to determine temperature.

Note:
caves go infinitly deep, or at least until the 64 bit integer in the reandomizer is exceeded.
Same with floating islands.
