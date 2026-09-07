import { useId, type ReactNode } from "react";
import { Sprout } from "lucide-react";

import { cn } from "@/lib/utils";

export function EmptyState({
  title,
  description,
  actions,
  icon,
  compact = false,
  className,
}: {
  title: string;
  description?: string;
  actions?: ReactNode;
  icon?: ReactNode | false;
  compact?: boolean;
  className?: string;
}) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center text-center",
        compact ? "px-4 py-8" : "min-h-72 px-6 py-12",
        className,
      )}
    >
      {icon !== false ? (
        <span className="flex size-11 items-center justify-center rounded-full bg-muted text-muted-foreground">
          {icon ?? <Sprout className="size-5" aria-hidden="true" />}
        </span>
      ) : null}
      <h3
        className={cn(
          icon === false ? undefined : "mt-3",
          "text-sm font-semibold",
        )}
      >
        {title}
      </h3>
      {description ? (
        <p className="mt-2 max-w-md text-sm text-muted-foreground">
          {description}
        </p>
      ) : null}
      {actions ? <div className="mt-5">{actions}</div> : null}
    </div>
  );
}

export function FullScreenEmptyState({
  title,
  description,
  className,
}: {
  title: string;
  description: string;
  className?: string;
}) {
  const titleId = useId();
  return (
    <section
      data-slot="full-screen-empty-state"
      aria-labelledby={titleId}
      className={cn(
        "flex min-h-0 w-full flex-1 items-center justify-center px-6 py-12 text-center",
        className,
      )}
    >
      <div className="flex w-full max-w-lg flex-col items-center">
        <div
          data-slot="full-screen-empty-state-illustration"
          aria-hidden="true"
          className="relative isolate h-32 w-[13.5rem]"
        >
          <svg
            data-slot="full-screen-empty-state-graphic"
            viewBox="0 0 220 140"
            fill="none"
            className="h-full w-full"
          >
            <line
              x1="40"
              y1="0"
              x2="40"
              y2="140"
              stroke="currentColor"
              strokeOpacity="0.05"
              strokeWidth="0.5"
            />
            <line
              x1="110"
              y1="0"
              x2="110"
              y2="140"
              stroke="currentColor"
              strokeOpacity="0.05"
              strokeWidth="0.5"
            />
            <line
              x1="180"
              y1="0"
              x2="180"
              y2="140"
              stroke="currentColor"
              strokeOpacity="0.05"
              strokeWidth="0.5"
            />
            <line
              x1="0"
              y1="25"
              x2="220"
              y2="25"
              stroke="currentColor"
              strokeOpacity="0.05"
              strokeWidth="0.5"
            />
            <line
              x1="0"
              y1="70"
              x2="220"
              y2="70"
              stroke="currentColor"
              strokeOpacity="0.05"
              strokeWidth="0.5"
            />
            <line
              x1="0"
              y1="115"
              x2="220"
              y2="115"
              stroke="currentColor"
              strokeOpacity="0.05"
              strokeWidth="0.5"
            />
            <polygon
              points="89,58 110,70 110,94 89,106 68,94 68,70"
              fill="none"
              stroke="currentColor"
              strokeOpacity="0.28"
              strokeWidth="0.75"
              strokeLinejoin="round"
            />
            <line
              x1="89"
              y1="82"
              x2="68"
              y2="70"
              stroke="currentColor"
              strokeOpacity="0.18"
              strokeWidth="0.5"
            />
            <line
              x1="89"
              y1="82"
              x2="110"
              y2="70"
              stroke="currentColor"
              strokeOpacity="0.18"
              strokeWidth="0.5"
            />
            <line
              x1="89"
              y1="82"
              x2="89"
              y2="106"
              stroke="currentColor"
              strokeOpacity="0.18"
              strokeWidth="0.5"
            />
            <polygon
              points="110,46 131,58 131,82 110,94 89,82 89,58"
              fill="none"
              stroke="currentColor"
              strokeOpacity="0.38"
              strokeWidth="0.75"
              strokeLinejoin="round"
            />
            <line
              x1="110"
              y1="70"
              x2="89"
              y2="58"
              stroke="currentColor"
              strokeOpacity="0.25"
              strokeWidth="0.5"
            />
            <line
              x1="110"
              y1="70"
              x2="131"
              y2="58"
              stroke="currentColor"
              strokeOpacity="0.25"
              strokeWidth="0.5"
            />
            <line
              x1="110"
              y1="70"
              x2="110"
              y2="94"
              stroke="currentColor"
              strokeOpacity="0.25"
              strokeWidth="0.5"
            />
            <polygon
              points="131,34 152,46 152,70 131,82 110,70 110,46"
              fill="none"
              stroke="currentColor"
              strokeOpacity="0.5"
              strokeWidth="0.75"
              strokeLinejoin="round"
            />
            <line
              x1="131"
              y1="58"
              x2="110"
              y2="46"
              stroke="currentColor"
              strokeOpacity="0.35"
              strokeWidth="0.5"
            />
            <line
              x1="131"
              y1="58"
              x2="152"
              y2="46"
              stroke="currentColor"
              strokeOpacity="0.35"
              strokeWidth="0.5"
            />
            <line
              x1="131"
              y1="58"
              x2="131"
              y2="82"
              stroke="currentColor"
              strokeOpacity="0.35"
              strokeWidth="0.5"
            />
            <path
              d="M148 22 L155 26 L148 30 L141 26 Z"
              fill="none"
              stroke="currentColor"
              strokeOpacity="0.18"
              strokeWidth="0.5"
              strokeDasharray="2 2"
            />
            <circle cx="40" cy="70" r="1.5" fill="currentColor" opacity="0.1" />
            <circle
              cx="180"
              cy="70"
              r="1.5"
              fill="currentColor"
              opacity="0.1"
            />
            <circle
              cx="110"
              cy="25"
              r="1.5"
              fill="currentColor"
              opacity="0.07"
            />
          </svg>
        </div>
        <div className="mt-6 flex flex-col items-center gap-2">
          <h2
            id={titleId}
            className="text-xl leading-7 font-semibold tracking-tight"
          >
            {title}
          </h2>
          <p className="max-w-md text-sm leading-5 text-muted-foreground">
            {description}
          </p>
        </div>
      </div>
    </section>
  );
}
