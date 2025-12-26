const express = require('express');
const axios = require('axios');
const cors = require('cors');
const morgan = require('morgan');

const PORT = process.env.PORT || 3000;
const DICTIONARY_API = 'https://api.dictionaryapi.dev/api/v2/entries/en';

const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

app.get('/api/define', async (req, res) => {
  const word = (req.query.word || '').toString().trim().toLowerCase();

  if (!word) {
    return res.status(400).json({ error: 'word-required', message: 'Query param "word" is required.' });
  }

  try {
    const { data } = await axios.get(`${DICTIONARY_API}/${encodeURIComponent(word)}`);
    if (!Array.isArray(data) || data.length === 0) {
      return res.status(404).json({ error: 'not-found', message: 'Word not found.' });
    }

    const entry = data[0];
    const phonetic = entry.phonetic || (entry.phonetics || []).find((p) => p.text)?.text || '';

    const simplified = {
      word: entry.word || word,
      phonetic,
      meanings: (entry.meanings || [])
        .map((meaning) => ({
          partOfSpeech: meaning.partOfSpeech || '',
          definitions: (meaning.definitions || [])
            .filter((d) => d && d.definition)
            .map((d) => ({
              definition: d.definition || '',
              example: d.example || '',
            })),
        }))
        .filter((m) => m.definitions.length > 0),
    };

    return res.json(simplified);
  } catch (err) {
    const status = err.response?.status;
    if (status === 404) {
      return res.status(404).json({ error: 'not-found', message: 'Word not found.' });
    }

    console.error('Dictionary API error', err.message);
    return res.status(502).json({ error: 'upstream-failed', message: 'Dictionary service failed. Try again later.' });
  }
});

app.use((req, res) => {
  res.status(404).json({ error: 'route-not-found' });
});

app.listen(PORT, () => {
  console.log(`Dictionary proxy listening on http://localhost:${PORT}`);
});
