# Sample catalog content

> Shape reference from early product definition.  
> **Not** the full official catalog. Formal source and complete list: **D-023** / private data repo.

## Field `referencias` (articles / resolutions)

Optional list of norms tied to a code. Shown in the **detail** sheet when the user taps an infraction.

```json
"referencias": ["Art. 131", "Res. 20"]
```

| Sample code | Example referencias in seed |
| --- | --- |
| C.28 | Art. 131, Res. 20 |
| C.38 | Art. 131, Ley 1696 |
| C.06 | Art. 82 |

Real values are filled by the promoter when curating content.

## Categories (sample)

### A — Non-motor vehicles
Includes codes such as A.01 … A.06 (keep right, grab moving vehicle, sidewalks, signals, lights, …).

### B — Driver / owner
Includes B.01, B.03, B.04, B.06, B.08, B.10 (license on person, plates, tolls, tint, …).

### C — Higher ordinary fines
Includes C.01 … C.39 samples (seat belt, motorcycle rules, resonators **C.28**, speeding, phone use **C.38**, …).

Full tables live in `app/assets/data/catalogo_seed.json` and private `catalogo.json`.
