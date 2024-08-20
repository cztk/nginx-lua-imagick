-- /etc/nginx/lua/ffi_definitions.lua
local ffi = require "ffi"

ffi.cdef[[
            typedef unsigned int mode_t;
            typedef unsigned long dev_t;
            typedef unsigned long ino_t;
            typedef unsigned int nlink_t;
            typedef unsigned int uid_t;
            typedef unsigned int gid_t;
            typedef long off_t;
            typedef long blksize_t;
            typedef long blkcnt_t;
            typedef long time_t;

            int mkdir(const char *pathname, mode_t mode);
            int access(const char *path, int mode);

            struct s_stat {
                dev_t     st_dev;     /* ID of device containing file */
                ino_t     st_ino;     /* inode number */
                mode_t    st_mode;    /* protection */
                nlink_t   st_nlink;   /* number of hard links */
                uid_t     st_uid;     /* user ID of owner */
                gid_t     st_gid;     /* group ID of owner */
                dev_t     st_rdev;    /* device ID (if special file) */
                off_t     st_size;    /* total size, in bytes */
                blksize_t st_blksize; /* blocksize for file system I/O */
                blkcnt_t  st_blocks;  /* number of 512B blocks allocated */
                time_t    st_atime;   /* time of last access */
                time_t    st_mtime;   /* time of last modification */
                time_t    st_ctime;   /* time of last status change */
            };

            int stat(const char *path, struct s_stat *buf);

        ]]

return ffi
