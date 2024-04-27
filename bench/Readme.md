### Result

**What's [poop](https://github.com/andrewrk/poop)?**

This tool uses Linux's `perf_event_open` functionality to compare the performance.

```bash
# BUILD
$ gcc -o bench_c bench.c -L$PWD/zig-out/lib -lgc -Os
$ ldmd2 --release -O bench.d -of=bench_d
# RUN
$ poop -d 100 './bench_c' './bench_d'
Benchmark 1 (12 runs): ./bench_c
  measurement          mean ± σ            min … max           outliers         delta
  wall_time          6.77ms ± 97.0us    6.58ms … 7.00ms          3 (25%)        0%
  peak_rss           2.06MB ± 59.3KB    1.97MB … 2.10MB          3 (25%)        0%
  cpu_cycles         26.9M  ±  304K     26.3M  … 27.4M           0 ( 0%)        0%
  instructions        100M  ±  371K     99.6M  …  101M           0 ( 0%)        0%
  cache_references   1.05M  ± 58.9K      965K  … 1.13M           0 ( 0%)        0%
  cache_misses       81.8K  ± 28.7K     30.8K  …  113K           0 ( 0%)        0%
  branch_misses      35.5K  ±  493      34.7K  … 36.6K           1 ( 8%)        0%
Benchmark 2 (90 runs): ./bench_d
  measurement          mean ± σ            min … max           outliers         delta
  wall_time          1.09ms ± 89.1us     893us … 1.48ms          3 ( 3%)        ⚡- 84.0% ±  0.8%
  peak_rss           2.42MB ± 79.2KB    2.36MB … 2.62MB          0 ( 0%)        💩+ 17.5% ±  2.3%
  cpu_cycles         1.52M  ±  104K     1.43M  … 1.99M           3 ( 3%)        ⚡- 94.4% ±  0.3%
  instructions       4.52M  ±  360      4.52M  … 4.52M           0 ( 0%)        ⚡- 95.5% ±  0.1%
  cache_references   29.7K  ±  308      28.9K  … 30.6K           2 ( 2%)        ⚡- 97.2% ±  1.1%
  cache_misses       9.72K  ±  174      9.34K  … 10.3K           4 ( 4%)        ⚡- 88.1% ±  7.1%
  branch_misses      5.81K  ± 39.1      5.73K  … 5.95K           1 ( 1%)        ⚡- 83.7% ±  0.3%
```