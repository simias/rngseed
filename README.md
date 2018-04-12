# RNGseed

`rngseed` is a small utility used to seed linux's RNG from a file (or stdin). Unlike simply `cat`'ing the file into `/dev/urandom` this utility also increases the measure of the entropy available in the kernel (through the use of the `RNDADDENTROPY` ioctl). The usage is trivial, simply provide a file name as an argument and `rngseed` will add the content of the file to the kernel's entropy pool. If no argument is provided `stdin` is read instead:

```sh
# rngseed my_entropy_file
# echo "some random data" | rngseed
```

This is useful to speed up the initialization of linux's random system after boot on systems where there's not a lot of good entropy sources available. Calls like `getrandom(2)` will block even if they read from `urandom` if the entropy pool has not yet been initialized. On certain systems, notably embedded, it can take a lot of time for enough entropy to be harvested (several minutes) which slows down the boot process dramatically. Using `rngseed` you can instead seed the initial entropy pool from a file containing good quality random data.

If you want something more fully-featured have a look at the `rng-tools` which can do what this utility does and much more.

## Warning

Make sure an attacker can't get access to your entropy file otherwise they might be able to guess the state of the RNG.

Obviously if you want good quality random data you should only use this utility with files containing actual random data and you should not reuse the same data to seed the RNG multiple times since it could result in the pool being initialized in a similar state every time and therefore become predictable. A simple way to avoid that is to overwrite entropy file with "fresh" random data right after seeding:

```sh
# rngseed my_entropy_file
# dd if=/dev/urandom bs=2048 count=1 of=my_entropy_file
```

It might also be a good idea to refresh the file with fresh random data once the system has harvested good quality entropy from other sources. This can be done on system shutdown or regularly through a cron task for instance.
