# Используем образ с Node.js 20
FROM node:20-bookworm

# Устанавливаем системные зависимости 
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-pip \
    python3-venv \
    git \
    && rm -rf /var/lib/apt/lists/*

# Настраиваем виртуальное окружение Python
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Устанавливаем AI-библиотеки
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
# Ставим сам Whisper и обертку auto-subtitle
RUN pip install openai-whisper
RUN pip install git+https://github.com/m1guelpf/auto-subtitle.git

# Устанавливаем n8n глобально
RUN npm install -g n8n

# Создаем рабочую директорию и права для пользователя node
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

# Переключаемся на пользователя node 
USER node
WORKDIR /home/node

# 6. Запускаем n8n
EXPOSE 5678
CMD ["n8n"]
