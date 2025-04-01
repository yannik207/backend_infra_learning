The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.
The database cluster will be initialized with locale "en_US.utf8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".
Data page checksums are disabled.
initdb: error: directory "/var/lib/postgresql/data" exists but is not empty
initdb: detail: It contains a lost+found directory, perhaps due to it being a mount point.
initdb: hint: Using a mount point directly as the data directory is not recommended.
Create a subdirectory under the mount point.


answer:
This error occurs when running PostgreSQL in a container where the data directory is mounted directly to a filesystem mount point. The issue is that the mount point already contains a lost+found directory (which is normal for ext filesystems), but PostgreSQL's initdb requires an empty directory to initialize the database.

The PGDATA environment variable tells PostgreSQL to use /var/lib/postgresql/data/pgdata as its data directory, which is a subdirectory of the mount point. PostgreSQL will create this subdirectory automatically when it initializes.
This is a common issue when running PostgreSQL in containers, and using the PGDATA environment variable is the standard solution.


# poetry:
So far so good, but our Docker build still suffers from a very painful point: every time we modify our code we’ll have to re-install our dependencies! That’s because we COPY our code (which is needed by Poetry to install the project) before the RUN poetry install instruction. Because of how Docker layer caching works, every time the COPY layer is invalidated we’ll also rebuild the successive ones. As your project grows this can get very tedious and result in very long builds even if you are just changing a single line of code.
The solution here is to provide Poetry with the minimal information needed to build the virtual environment and only later COPY our codebase. We can achieve this with the --no-root option, which instructs Poetry to avoid installing the current project into the virtual environment.