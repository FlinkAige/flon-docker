
#!/bin/bash
if [ -f ~/flon.env ]; then
  source ~/flon.env
fi

docker run -d --name flon-build -v /opt/data:/mnt ${NODE_IMG_HEADER}fullon/floncdt:$CDT_VERSION tail -f /dev/null