# Location of badblocks on my Mac is /usr/local/Cellar/e2fsprogs/1.46.2_1/sbin/badblocks
badblocks_path=/usr/local/Cellar/e2fsprogs/1.46.2_1/sbin/badblocks

# The options
# -n non destructive read/write test. It reads the data 4 times and writes it 4 times. It is slow.
# -v verbos
# -s progress stats. Displays a rough estimate of the durationa and percent completed.
# -b blocksize - normally 512 bytes
# -c cluster size? how many blocks to read. This improves speed significantly.
# Use both -b and -c to have the optimum speed. Otherwise the test takes too long.
# You can specify an offset at the end if want to continue a previous test.
# The format is end_offset start_offset after the /dev/disk2
sudo $badblocks_path -svn -b 512 -c 65536 /dev/disk2
