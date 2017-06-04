Setup
===
* **Install** [Git for Windows](https://git-scm.com/download/win)
* **Install** [Docker for Windows](https://docs.docker.com/docker-for-windows/install) (recommended: Stable Channel)
* **Checkout** the `arrisray/jira-container` repo
* **Create** a named volume for persistent storage
    * **Problem**: ["The outcome of what you're attempting is that [the database] running in Linux will be writing to a Windows NTFS filesystem mounted over SAMBA/CIFS - that may not work. We're working on improving the filesystem semantics."](https://forums.docker.com/t/volume-binds-issue/17218/4)
    * **Solution**: Run `docker volume create --name jira-db-volume -d local`
    * **See**: [Docker Community Forums, "Trying to get Postgres to work on persistent windows mount - two issues"](https://forums.docker.com/t/trying-to-get-postgres-to-work-on-persistent-windows-mount-two-issues/12456/5?u=friism)
* **Run** `docker-compose up` in the directory to which you checked out the repo
* **Expose** TCP/8080 in your Windows Firewall to allow access to Jira over your network
